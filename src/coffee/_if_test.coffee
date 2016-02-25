class IfTest
  strArr = [
    'null'
    'undefined'
    'false'
    '"false"'
    'Boolean(false)'
    '[]'
    '[[]]'
    '""'
    'String("")'
    '0'
    'Number(0)'
    '"0"'
    'String("0")'
    '[0]'
    'true'
    '"true"'
    'Boolean(true)'
    '1'
    'Number(1)'
    '"1"'
    'String("1")'
    '[1]'
    '-1'
    'Number(-1)'
    '"-1"'
    'String("-1")'
    '[-1]'
    'Infinity'
    '-Infinity'
    'Object()'
    'NaN'
  ]
  ColorMap = [
    '#3498DB'
    '#2ecc71'
    '#EB6C5F'
    '#BDC3C7'
  ]


  constructor: (svgId, option = {}) ->
    @size = option.size || 20
    @gap = option.gap || 2
    @width = (@gap + @size)*strArr.length - @gap
    @height = @size * 4
    @padding = option.padding || 180
    @res

    @svg = d3.select "##{svgId}"
      .attr 'width', @width + 2*@padding
      .attr 'height', @height + 2*@padding
      .append 'g'
        .attr 'transform', 'translate(' + @padding + ',' + @padding + ')'

    @calc()
    @draw()

  calc: =>
    @ifRes = []
    @falseRes = []
    @trueRes = []
    @var = strArr.map (e) -> eval(e)
    for v in @var
      if v then @ifRes.push 0 else @ifRes.push 3
      if `v == true` then @trueRes.push 1 else @trueRes.push 3
      if `v == false` then @falseRes.push 2 else @falseRes.push 3

  draw: =>
    str = strArr
    len = strArr.length
    c = ColorMap

    ifRect = @svg.selectAll 'rect.if'
      .data @ifRes
      .enter()
      .append 'rect'
      .attr 'class', 'if'
      .attr 'y', 0
      .attr 'x', (d, i) =>
        i%len*@size + i%len*@gap
      .attr 'width', @size
      .attr 'height', 2*@size
      .style 'fill', (d) -> c[d]

    ifRect = @svg.selectAll 'rect.true'
      .data @trueRes
      .enter()
      .append 'rect'
      .attr 'class', 'true'
      .attr 'y', 2*@size + @gap
      .attr 'x', (d, i) =>
        i%len*@size + i%len*@gap
      .attr 'width', @size
      .attr 'height', 2*@size
      .style 'fill', (d) -> c[d]

    ifRect = @svg.selectAll 'rect.false'
      .data @falseRes
      .enter()
      .append 'rect'
      .attr 'class', 'false'
      .attr 'y', 4*@size + 2*@gap
      .attr 'x', (d, i) =>
        i%len*@size + i%len*@gap
      .attr 'width', @size
      .attr 'height', 2*@size
      .style 'fill', (d) -> c[d]

    @svg.selectAll '.xLabel'
      .data  str
      .enter()
      .append 'text'
      .text (d) -> d
      .attr 'class', 'xLabel'
      .style 'text-anchor', 'end'
      .attr 'transform', (d, i) =>
        "translate(#{i%len*@size + i%len*@gap + 4}, -4) rotate(90)"

    @svg.selectAll '.yLabel'
      .data [
              'what goest through if'
              'what equals (==) true'
              'what equals (==) false'
            ]
      .enter()
      .append 'text'
      .text (d) -> d
      .attr 'class', 'yLabel'
      .style 'text-anchor', 'end'
      .attr 'transform', (d, i) =>
        "translate(-8, #{i%len*2*@size + i%len*@gap + 28})"

exports = module.exports = IfTest
