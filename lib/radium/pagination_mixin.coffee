Radium.PaginationMixin = Ember.Mixin.create
  perPage: 7
  currentPage: 1

  currentLimit: (->
    @get('currentPage') * @get('perPage')
  ).property('content', 'currentPage', 'perPage')

  limitedContent: (->
    currentLimit = @get 'currentLimit'

    if content = @get('content')
      Ember.A(content.slice(0, currentLimit))
  ).property('content')

  # FIXME: Should this go in a separate mixin
  pagedContent: ( ->
    currentPage = @get('currentPage')
    contentLength = @get('content.length')
    pageSize = @get('perPage')
    start = @get('pageStart')

    end = (start + pageSize)

    @get('content').slice(start, end)
  ).property('currentPage', 'content', 'content.length')

  showPreviousPage: ->
    return if @get('currentPage') <= 1

    @set 'currentPage', @get('currentPage') - 1

  pageStart: ( ->
    currentPage = @get('currentPage')
    start = @getPageStart(currentPage)
  ).property('currentPage', 'content', 'content.length')

  canPageForward: ( ->
    currentPage = @get('currentPage') + 1
    start = @getPageStart(currentPage) + 1
    contentLength = @get('content.length')

    (start <= contentLength)
  ).property('currentPage', 'content', 'content.length')

  getPageStart: (startIndex) ->
    pageSize = @get('perPage')
    ((((startIndex - 1) * pageSize) + 1) - 1)

  showNextPage: ->
    @set('currentPage', @get('currentPage') + 1) if @get('canPageForward')

  showMore: ->
    currentLimit  = @get 'currentLimit'
    contentLength = @get 'arrangedContent.length'
    length        = @get 'limitedContent.length'

    newLimit      = currentLimit + @get('perPage')
    newLimit      = contentLength if newLimit > contentLength

    @set 'currentLimit', newLimit

    if length < newLimit
      for i in [(length)..(newLimit - 1)]
        @get('limitedContent').pushObject( @objectAtContent(i) )

    @set 'currentPage', @get('currentPage') + 1

  totalLength: (->
    @get('content.length')
  ).property('content', 'content.length')

  remainingContent: ( ->
    if content = @get('arrangedContent')
      Ember.A(content.slice(@get('currentLimit') + 1, @get('content.length')))
  ).property('arrangedContent', 'currentLimit')

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    if addedCount
      for i in [idx..(idx + addedCount - 1)]
        if @get('limitedContent.length') < @get('currentLimit')
          @get('limitedContent').pushObject( @objectAtContent(i) )

    @_super.apply(this, arguments)

  contentArrayWillChange: (array, idx, removedCount, addedCount) ->
    if removedCount
      for i in [idx..(idx + removedCount - 1)]
        @get('limitedContent').removeObject( @objectAtContent(i) )

    @_super.apply(this, arguments)


  replaceContent: (idx, amt, objects) ->
    @get('content').replace(idx, amt, objects)
