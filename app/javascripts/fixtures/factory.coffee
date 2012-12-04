window.Factory = do($) ->
  f = {}

  Definition = (name, options) ->
    @name = name
    @defaults = $.extend options.parent, options.defaults
    @plural = "#{name.toLowerCase().pluralize()}"
    @sequences = options.sequences
    @

  define = (klass, options = {}) ->
    options.defaults ?= {}
    options.parent = if options.parent then build(options.parent) else {}

    setSequence(options) if options.sequence

    def = new Definition(klass, options)

    f[klass] = def
    f[def.plural] = {} unless f[def.plural]

    return if options.abstract

    unless f[def.plural].default
      f[def.plural].default = build(klass, def.defaults)

  setSequence = (options) ->
    options.sequences = {}
    options.sequences.attr = options.sequence
    options.defaults[options.sequence] = 0
    options.sequences[options.sequence] = ->
      nextSequence = ++options.defaults[options.sequence]
      options.defaults[options.sequence] = nextSequence

  build = (klass, name, options = {}) ->
    unless f.hasOwnProperty klass
      throw "there is no factory definition for #{klass}"

    if arguments.length == 2 && typeof name == 'object'
      options = name
      name = null

    options ?= {}
    definition = f[klass]

    instance = $.extend {}, definition.defaults, options

    def = f[klass]
    instance.def = def

    if def.sequences
      instance[def.sequences.attr] = def.sequences[def.sequences.attr]()

    for k, v of instance when typeof v is 'function'
      #do we need to worry about context?
      result = instance[k]()
      delete instance[k]
      instance[k] = result

    if typeof name == "string"
      f[definition.plural][name] = instance

    instance

  getDefinitions = ->
    for own key, value of f
      continue if typeof value is "function"
      continue if value instanceof Definition
      value

  association = (klass) ->
    unless f.hasOwnProperty klass
      throw "there is no factory definition for #{klass}"

    args = Array.prototype.slice.call(arguments)
    type = klass.pluralize().toLowerCase()

    if $.isArray args[1]
      if args.length is 3 and typeof args[2] is "object" and args[2].embedded
        return (f[type][instance] for instance in args[1])

      return (f[type][instance].id for instance in args[1])

    instance = f[type][args[1]]

    if args.length is 3 and typeof args[2] is 'object'
      instance = $.extend {}, instance, args[2]

    instance

  tearDown = ->
    for own key, value of f
      continue if typeof value is "function"
      delete f[key]

  f.define =  define
  f.build =  build
  f.getDefinitions = getDefinitions
  f.association = association
  f.tearDown = tearDown
  f
