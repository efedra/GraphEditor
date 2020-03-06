import React, {Component} from 'react'
import * as d3 from "d3";

class drawGraph extends Component{

    // set up SVG for D3
    state = {
        width: window.innerWidth,
        height: window.innerHeight,
        radiusNode: 20
    };


    draw() {
        const svg = d3.select('body').append('svg').attr("width", this.state.width)
            .attr("height", this.state.height);
        let that = this;


        //draw Lines
        const line = svg.selectAll('line')
            .data(that.props.graph.edges)
            .enter()
            .append('line')
            .attr('x1',function (d) {
                return that.props.graph.nodes[d.from].x})
            .attr('y1',function (d) {
                return that.props.graph.nodes[d.from].y})
            .attr('x2',function (d) {
            return that.props.graph.nodes[d.to].x})
            .attr('y2',function (d) {
                return that.props.graph.nodes[d.to].y})
            .attr('stroke','black')
            .attr('stroke-width',3)
            .attr('marker-end','url(#arrowhead)')

        //draw Circles
        const circle =svg.selectAll('circle').data(that.props.graph.nodes)
            .enter()
            .append('circle')
            .attr('cx',function (d) { return d.x})
            .attr('cy', function(d){return d.y})
            .attr('r',that.state.radiusNode)
            .attr('fill','green')
            .attr('stroke','black')
            .attr('stroke-width',2)


        const Text=svg.selectAll('text')
            .data(that.props.graph.nodes)
            .enter()
            .append('text')
            .attr('x',function (d){return d.x})
            .attr('y',function (d){return d.y})
            .text(function(d){return d.text} )
            .attr("text-anchor", "middle")


        const markerLines = svg.append('defs')
            .append('marker')
            .attr('id','arrowhead')
            .attr('markerWidth',20)
            .attr('markerHeight',12)
            .attr('refX',12)
            .attr('refY',3.5)
            .attr('orient','auto')
            .append ("polygon") .attr ("points", "0 0, 6 3.5, 0 6");




    }



    render(){
        return(
            <div>
                {this.draw()}
            </div>
        )
    }
}

export default drawGraph