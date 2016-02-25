class BinaryOp
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

  Type = [
    '==='
    '=='
    '>= && <='
    '>='
    '<='
    'else'
  ]

  ColorMap = [
    '#902B20'
    '#EB6C5F'
    '#f1c40f'
    '#2ecc71'
    '#3498db'
    '#bdc3c7'
  ]

  constructor: (svgId, option = {}) ->
    @size = option.size || 20
    @gap = option.gap || 2
    @width = (@gap + @size)*strArr.length - @gap
    @height = (@gap + @size)*strArr.length - @gap
    @padding = option.padding || 120
    @res

    @svg = d3.select "##{svgId}"
      .attr 'width', @width + 2*@padding + 50 #legend space
      .attr 'height', @height + 2*@padding
      .append 'g'
        .attr 'transform', 'translate(' + @padding + ',' + @padding + ')'
    @calc()
    @draw()

  calc: () =>
    @res = []
    @var1 = strArr.map (e) -> eval(e)
    @var2 = strArr.map (e) -> eval(e)

    for v1 in @var1
      for v2 in @var2
        if v1 is v2
          @res.push 0 # 0 for ===
        else if `v1 == v2`
          @res.push 1 # 1 for ==
        else if v1 >= v2 && v1 <= v2
          @res.push 2 # 2 for <= and >= but not ==, WTF
        else if v1 >= v2
          @res.push 3 # 3 for >=
        else if v1 <= v2
          @res.push 4 # 4 for <=
        else
          @res.push 5 # 5 for else

  draw: =>
    str = strArr
    len = strArr.length
    c = ColorMap
    t = Type

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
      .data  str
      .enter()
      .append 'text'
      .text (d) -> d
      .attr 'class', 'yLabel'
      .style 'text-anchor', 'end'
      .attr 'transform', (d, i) =>
        "translate(-4, #{i%len*@size + i%len*@gap + 16})"

    rect = @svg.selectAll 'rect'
      .data @res
      .enter()
      .append 'rect'
      .attr 'y', (d, i) =>
        ~~(i/len)*@size + ~~(i/len)*@gap
      .attr 'x', (d, i) =>
        i%len*@size + i%len*@gap
      .attr 'width', @size
      .attr 'height', @size
      .style 'fill', c[5]

    rect.transition()
      .duration 200
      .ease 'easeInOutCubic'
      .delay (d, i) ->
        ~~(i/len)*120 + i%len*40
      .style 'fill', (d) ->
        c[d]

    legends = @svg.selectAll '.legend'
      .data t
      .enter()
      .append 'g'
      .attr 'class', 'legend'
      .attr 'transform', (d, i) =>
        "translate(#{len*@size + len*@gap + 40}, #{i*60})"
      .on 'mouseover', (d, i) ->
        rect.transition()
          .duration 200
          .ease 'easeInOutCubic'
          .style 'fill', (data) ->
            if data is i then d else c[5]

      .on 'mouseout', (d, i) ->
        rect.transition()
          .duration 200
          .ease 'easeInOutCubic'
          .style 'fill', (data) ->
            c[data]


    legends
      .append 'rect'
      .attr 'width', @size*1.5
      .attr 'height', @size*1.5
      .style 'fill', (d, i) ->
        c[i]

    legends
      .append 'text'
      .text (d) -> d
      .style 'text-anchor', 'start'
      .attr 'x', @size*2
      .attr 'y', 18

exports = module.exports = BinaryOp
