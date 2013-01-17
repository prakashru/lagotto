var data = <%= @articles %>;
var labels = <%= raw @labels %>;
  
var l = 200; // left margin
var r = 120; // right margin
var w = 600; // width of drawing area
var h = 30;  // bar height
var s = 1;   // spacing between bars
  
var chart = d3.select("div#article").append("svg")
  .attr("width", w + l + r)
  .attr("height", data.length * (h + 2 * s) + 30)
  .attr("class", "chart")
  .append("g")
  .attr("transform", "translate(230,20)");
var x = d3.scale.linear()
  .domain([0, d3.max(data)])
  .range([1, w]);
var y = d3.scale.ordinal()
  .domain(labels)
  .rangeBands([0, (h + 2 * s) * labels.length]);
chart.selectAll("text.labels")
  .data(labels)
  .enter().append("text")
  .attr("x", 0)
  .attr("y", function(d) { return y(d) + y.rangeBand() / 2; })
  .attr("dx", -230) // padding-right
  .attr("dy", ".35em") // vertical-align: middle
  .text(String)
chart.selectAll("rect")
  .data(data)
  .enter().append("rect")
  .attr("fill", "#789aa1")
  .attr("y", y)
  .attr("width", x)
  .attr("height", h);
chart.selectAll("text.values")
  .data(data)
  .enter().append("text")
  .attr("x", x)
  .attr("y", function(d) { return y(d) + y.rangeBand() / 2; })
  .attr("dx", 5) // padding-right
  .attr("dy", ".35em") // vertical-align: middle
  .text(function(d) { return d.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); })