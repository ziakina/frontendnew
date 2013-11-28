Radium.DateRangeComponent = Ember.Component.extend
  classNames: "date-range"
  width: null
  height: 100
  source: null
  margin: {top: 0, right: 30, bottom: 15, left: 30}
  domain: [new Date(2013, 0, 1), new Date(2013, 11, 31)]

  componentWidth: (->
    if @get('width') is null then @$().parent().innerWidth() else @get('width')
  ).property('width')

  setupCanvas: (->
    width = @get 'componentWidth'
    height = @get 'height'
    margin = @get 'margin'
    domain = @get 'domain'

    svg = @svg = d3.select(this.$()[0]).append("svg")

    contextXScale = d3.time.scale()
                    .range([0, width - 8])
                    .domain(domain)

    contextAxis = @axis = d3.svg.axis()
                    .scale(contextXScale)
                    .tickFormat((d) ->
                      format = d3.time.format('%b')
                      format(d)
                    )
                    .tickSize(10)
                    .orient("bottom")

    brush = @brush = d3.svg.brush()
                    .x(contextXScale)
                    .on("brush", @brushDidChange.bind(this))

    context = @svgContext = svg.append("g")
      .attr("class", "context")
      .attr("transform", "translate(#{(margin.left + width * .25)}, 0)")

    context.append("g")
      .attr("class", "x axis top")
      .attr("transform", "translate(0,0)")
      .call(contextAxis)
      .selectAll("text")
        .style("text-anchor", "start")

    context.append("g")
      .attr("class", "x brush")
      .call(brush)
      .selectAll("rect")
        .attr("y", 0)
        .attr("height", height - 2)

    @setDimensions()
    $(window).on('resize', @redraw.bind(this))
  ).on('didInsertElement')

  setDimensions: ->
    width = @$().parent().innerWidth()
    height = @get 'height'
    margin = @get 'margin'

    @svg.attr("width", width - 5)
        .attr("height", height)
    @svgContext.attr("transform", "translate(#{(width * .25)},")


  redraw: ->
    @setDimensions()
    @svg.selectAll(".brush").call(@brush);

  dateRangeDidChange: (->
    startDate = @get('startDate')
    endDate = @get('endDate')

    @brush.extent([startDate.toJSDate(), endDate.toJSDate()])
    @redraw()
  ).observes('startDate', 'endDate')

  brushDidChange: () ->
    if @brush.empty()
      @sendAction('reset')
    else
      extent = @brush.extent()
      @sendAction('filter', [extent[0], extent[1]])
    dc.redrawAll()

Ember.Handlebars.helper('date-range', Radium.DateRangeComponent)