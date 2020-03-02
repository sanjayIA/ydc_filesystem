/*eslint-disable no-shadow */
/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
/* eslint-disable no-alert */
/* global d3 */
// libsD3.js
import { LightningElement,api,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import D3 from '@salesforce/resourceUrl/Traceability';
import getTraceabilityData from '@salesforce/apex/Traceability.getTraceabilityData';

export default class Traceability extends LightningElement {
@api recordId;
@api objectApiName;
@track errors;
@api traceableData;
@api imgHeight;
@api nodeLength;
@api flexipageRegionHeight;
@api flexipageRegionWidth;
@wire(getTraceabilityData,{recordId:'$recordId'}) traceData
({ error, data }) {
if (data) {
this.traceableData=data;
  this.error = undefined;
  this.callback();
} else if (error) {
  this.error = error;
  this.traceableData = undefined;
}
}
d3Initialized = false;
callback() {
  if (this.d3Initialized) {
      return;
  }
  this.d3Initialized = true;
  Promise.all([
      loadScript(this, D3 + '/d3.v4.min.js'),
      loadStyle(this, D3 + '/style.css')
      
  ])
      .then(() => {
          this.initializeD3();
      })
      .catch(error => {
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Error loading D3',
                  message: error.message,
                  variant: 'error',
              }),
          );
      });
}


initializeD3() {
  let treeData,
  path,
  marginWidth=35;// adjusting the X Position of tree
  //parsing the String 
  treeData =JSON.parse(this.traceableData);
  //Size Adjustments betwwn Boxes
  const treeHeight=(treeData.children.length*50);
  //Dynamic Height Adjustements For the Boxes
  this.imgHeight=treeHeight;
  
  let children=treeData.children;
  //Incremental Height with Respect to Childs 
  let imghtIncrement=0;
  for(let i=0;i<children.length;i++)
  {
  imghtIncrement=imghtIncrement+50;
  }

  for(let i=0;i<children.length;i++)
  {
  if(children[i].children.length!==0)
  {
  marginWidth=20;
  break;
  }
  }
  //Predefined Box Size 
  let rectNode = {
  width: 120,
  height: 17,
  textMargin: 5
  };
  
  // Set the dimensions and margins of the diagram
  let margin = {top: 20, right: 120, bottom: 30, left: 160},
  width = 960 - margin.left - margin.right,
  height = 500 - margin.top - margin.bottom;
  
  // append the svg object to the body of the page
  // appends a 'group' element to 'svg'
  // moves the 'group' element to the top left margin
  let svg = d3.select(this.template.querySelector('svg.d3'))
  .attr("width", this.flexipageRegionWidth)
  .attr("height", this.imgHeight+imghtIncrement+100)
  .append("g")
  .style("transform",function(d){
  //adjusting te x position 
  let recordHeight;
  
  if(children.length===0){
  recordHeight=50
  }
  else{
  recordHeight=0
  }
  return "translate("+marginWidth+"%,"+recordHeight+"%)"});
  let i = 0,
  duration = 750,
  root;
  
  // declares a tree layout and assigns the size
  let treemap = d3.tree().size([this.imgHeight+imghtIncrement,this.flexipageRegionWidth]);
  
  // Assigns parent, children, height, depth
  root = d3.hierarchy(treeData, function(d) { return d.children; });
  root.x0 = height / 2;
  root.y0 = 0;
  if(root.hasOwnProperty("children"))
  //Only children will be collpased
  {
  root.children.forEach(collapse);
  }
  update(root);
  
  // Collapse the node and all it's children
  function collapse(d) {
  if(d.children) {
  d._children = d.children
  d._children.forEach(collapse)
  d.children = null
  }
  }
  
  function update(source) {
    svg.append("svg:defs").selectAll("marker")
    .data(["end"])      // Different link/path types can be defined here
  .enter().append("svg:marker")    // This section adds in the arrows
    .attr("id", String)
    .attr("viewBox", "0 -5 10 10")
    .attr("refX", 0)
    .attr("refY", 0)
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .attr('class', 'arrow')
    .attr("orient", "360")
  .append("path")
    .attr("d", "M0,-5L10,0L0,5");
  // Assigns the x and y position for the nodes
  treeData = treemap(root);
  
  // Compute the new tree layout.
  let nodes = treeData.descendants(),
  links = treeData.descendants().slice(1);
  
  // Normalize for fixed-depth.
  nodes.forEach(function(d){d.y = d.depth * 300});
  
  // ****************** Nodes section ***************************
  
  // Update the nodes...
  let node = svg.selectAll('g.node')
  .data(nodes, function(d) {return d.id || (d.id = ++i); });
  
  // Enter any new modes at the parent's previous position.
  let nodeEnter = node.enter().append('g')
  .attr('class', 'node')
  .attr("transform", function(d) {
  return "translate(" + source.y0 + "," + source.x0 + ")";
  })
  .on("click", click)
  // Add Circle for the nodes
  nodeEnter.append('circle')
  .attr('class', 'node')
  .attr('r', 1e-6)
  .style("fill", function(d) {
  return d.children ? "lightsteelblue" : "#fff";
  });
  
  
  let rectGrpEnter = nodeEnter.append('g')
  .attr('class', 'node-rect-text-grp');
  
  rectGrpEnter.append('rect')
  .attr('rx', 6)
  .attr('ry', 6)
  .attr('x',-107)
  .attr('y',-20)
  .style('fill', "#337ab7")
  .on("contextmenu", function(d) { window.open(d.data.url);})
  .attr('width',  function(d){return calculateRectWidth(d.data.objectType)})
  .attr('height', function(d){
  let rectVariedHeight;
  let nodeHeight=d.data.name == d.data.name.toLowerCase() ? 20:15;
  if(d.data.objectType.length>nodeHeight){
  nodeHeight=d.data.objectType.length;
  }
  if(Math.ceil(d.data.name.length/nodeHeight<1.01)){
  rectVariedHeight=40;
  }
  else
  {
  rectVariedHeight=rectNode.height*Math.ceil(d.data.name.length/nodeHeight)+15;
  }
  
  return rectVariedHeight; })
  .style("stroke-width", 1)
  .style("stroke", "#337ab7")
  .attr('class', 'node-rect');
  
  rectGrpEnter.append("text")
  .attr('ry', 0)
  .style("fill","white")
  .attr("dx", function(d) {
  let x=0;
  if(Math.ceil(d.data.name.length<15)){
  if(d.data.name.length>=13){
  x=-120
  }
  else{
  if(d.data.name.length>8){
  x=-140
  }
  else{
  x=-160;
  }
  }
  }
  else
  {
  x=-115;
  if(d.data.objectType.length>13){
  x=-68
  }
  }
  
  return d.children ? -190 : -220;
  })
  .attr("dy", "-5")
  .attr('cursor', 'pointer')
  .on("mouseover", function() {d3.select(this).style("fill", "#0000FF");})                  
  .on("mouseout", function() {d3.select(this).style("fill", "white");})
  .each(function(d) {
  let noofTextParts;
  let nodeHeight=d.data.name == d.data.name.toLowerCase() ? 20:15;
  if(d.data.objectType.length>nodeHeight){
  nodeHeight=d.data.objectType.length;
  }
  noofTextParts=Math.ceil(d.data.name.length/nodeHeight);
  // eslint-disable-next-line no-shadow
  for(let i=0;i<noofTextParts;i++)
  {
  d3.select(this).append("tspan")
  .attr("dy", i ? "1.2em" : -5)
  // eslint-disable-next-line no-unused-vars
  .attr("x", function(d2) {
  let len;
  if(i!==0)
  {
  len=-105;   
  }
  else
  {
  if(d2.children){
  len=85;
  } else
  {
  len= 115;
  }
  
  }
  return len;
  }
  )
  .attr("class", "tspan" + i)
  .style("text-anchor","start")
  .text(function(d1) {
  let nodeName;
  let nodeHeight= d1.data.name == d1.data.name.toLowerCase() ? 20:15;
  if(d1.data.objectType.length>nodeHeight)
  {
  nodeHeight=d1.data.objectType.length;
  }
  nodeName= d1.data.name.substring(i*nodeHeight,(i+1)*nodeHeight);
  return nodeName;
  });
  }
  });
  
  rectGrpEnter.append("text")
  .attr('ry', 0)
  .attr("text-anchor", "start")
  .attr("dy",function(d)
  {
  let noofTextParts;
  let nodeHeight=d.data.name == d.data.name.toLowerCase() ? 20:15;
  if(d.data.objectType.length>nodeHeight){
  nodeHeight=d.data.objectType.length;
  }
  noofTextParts=Math.ceil(d.data.name.length/nodeHeight);
  return noofTextParts > 3 ? 10*noofTextParts +5:10*noofTextParts;
  }
  
  )
  .attr("dx", "-105")
  .style("fill", "white")
  .text(function(d) { return "Type: "+d.data.objectType; });
  // UPDATE
  let nodeUpdate = nodeEnter.merge(node);
  
  // Transition to the proper position for the node
  nodeUpdate.transition()
  .duration(duration)
  .attr("transform", function(d) {
  return "translate(" + d.y + "," + d.x + ")";
  });
  let circleRadius = 0;
  // Update the node attributes and style
  nodeUpdate.select('circle.node')
  .attr('r', circleRadius)
  .style("fill", function(d) {
  return d._children ? "lightsteelblue" : "#fff";
  })
  .attr('cursor', 'pointer');
  
  // Remove any exiting nodes
  let nodeExit = node.exit().transition()
  .duration(duration)
  .attr("transform", function(d) {
  return "translate(" + source.y + "," + source.x + ")";
  })
  .remove();
  
  // On exit reduce the node circles size to 0
  nodeExit.select('circle')
  .attr('r', 1e-6);
  
  // On exit reduce the opacity of text labels
  nodeExit.select('text')
  .style('fill-opacity', 1e-6);
  
  // ****************** links section ***************************
  // Update the links...
  let link = svg.selectAll('g.link')
  .data(links, function (d) {
  return d.id;
  });
  // Enter any new links at the parent's previous position.
  let linkEnter = link.enter().insert('g', 'g')
  .attr("class", "link").attr("marker-start", "url(#end)");
  
  linkEnter.append('text')
  .attr("class","linkLabels")
  // eslint-disable-next-line no-shadow
  .text(function (d, i) {
  let linkName;
  if (d.parent && d.parent.children.length >= 1) {
  if (!d.parent.index) d.parent.index = 0;
  linkName=d.data.relationshipName;
  }
  return linkName;
  })
  .attr("opacity",0)
  .attr('dy', "-1em")
  .attr('dx', "-100");
  
  linkEnter.append('path')
  .attr('d', function (d) {
  let o = {
  x: source.x0,
  y: source.y0
  }
  return diagonal(o, o)
  })
  .on("mouseover", function(){
  d3.select(this.parentNode).select("text").attr("opacity",1).style("fill","Black");
  })
  .on("mouseleave", function(){
  
  d3.select(this.parentNode).select("text").attr("opacity",0);
  })
  .attr('cursor', 'pointer');
  
  
  // UPDATE
  let linkUpdate = linkEnter.merge(link);
  
  // Transition back to the parent element position
  linkUpdate.select('path').transition()
  .duration(duration)
  .attr('d', function (d) {
  return diagonal(d, d.parent)
  });
  
  linkUpdate.select('text').transition()
  .duration(duration)
  .attr('transform', function (d) {
  let translate;
  if (d.parent) {
  translate='translate(' + ((d.parent.y + d.y) / 2) + ',' + ((d.parent.x + d.x) / 2) + ')'
  }
  return translate;
  })
  
  // Remove any exiting links
  link.exit().each(function (d) {
  d.parent.index = 0;
  })
  
  let linkExit = link.exit()
  .transition()
  .duration(duration);
  
  linkExit.select('path')
  .attr('d', function (d) {
  let o = {
  x: source.x,
  y: source.y
  }
  return diagonal(o, o)
  })
  
  linkExit.select('text')
  .style('opacity', 0);
  
  linkExit.remove();
  
  // Store the old positions for transition.
  nodes.forEach(function (d) {
  d.x0 = d.x;
  d.y0 = d.y;
  });
  // Creates a curved (diagonal) path from parent to the child nodes
  function diagonal(s, d) {
  
  path = `M ${s.y- (rectNode.width + circleRadius) } ${s.x}
  C ${(s.y- (rectNode.width + circleRadius)  + d.y ) / 2} ${s.x},
  ${(s.y- (rectNode.width + circleRadius)  + d.y ) / 2} ${d.x},
  ${d.y } ${d.x}`
  
  return path
  }
  }
  // Toggle children on click.
  function click(d) {
  if (d.children) {
  d._children = d.children;
  d.children = null;
  } else {
  d.children = d._children;
  d._children = null;
  }
  update(d);
  }
  function calculateRectWidth(name)
  {
  let rectwidth;
  if(name.length >=0 && name.length <=15)
  {
  rectwidth=rectNode.width;
  }
  else {
  let substring= name.substring(15,name.length)
  rectwidth=rectNode.width + (substring.length *7);
  }
  return rectwidth;
  }
  }
  }