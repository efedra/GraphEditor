import React, {Component} from 'react'
import * as d3 from "d3";

class drawGraph extends Component{
    componentDidMount() {
        this.draw();
    }
    // set up SVG for D3
    state = {
        width: window.innerWidth,
        height: window.innerHeight,
        radiusNode: 20
    }


    draw() {
        const svg = d3.select('body').append('svg').attr("width", this.state.width)
            .attr("height", this.state.height);
        let that = this;
        //draw Circles
        const circle =svg.selectAll('circle').data(that.props.graph.nodes)
            .enter()
            .append('circle')
            .attr('cx',function (d) { return d.x})
            .attr('cy', function(d){return d.y})
            .attr('r',that.state.radiusNode)
            .attr('fill','grey');

        //draw Lines
        const line = svg.selectAll('line').data(that.props.graph.edges)
            .enter()
            .append('line')
            .attr('x1',function (d,i) {
                return that.props.graph.nodes[d.from].x})
            .attr('y1',function (d,i) {
                return that.props.graph.nodes[d.from].y})
            .attr('x2',function (d,i) {
            return that.props.graph.nodes[d.to].x})
            .attr('y2',function (d,i) {
                return that.props.graph.nodes[d.to].y})
            .attr('stroke','black')
            .attr('stroke-width',3)

        //draw triangle

            //insert text in nodes
            svg.selectAll('text')
                .data(that.props.graph.nodes)
                .enter()
            .append('text')
            .text(function (d) { return d.text})
            .attr('x',function (d) { return d.x+that.state.radiusNode +2})
            .attr('y',function(d){return d.y+that.state.radiusNode +2})

       /* const events = [];
       svg.on('click', function () {
            events.push(d3.event);
            if (events.length > that.props.graph.nodes.length) events.shift();
            const circles = svg.selectAll('circle')
                .data(events)
                .enter()
                .append('circle')
                .attr('cx', function (d) { return d.x || d.pageX })
                .attr('cy', function (d) { return d.y || d.pageY })
                .attr('fill', 'red')
                .attr('r', 10);
            circles
                .exit()
                .remove();
        });*/


    }



    render(){
        return(
            <div>

            </div>
        )
    }
}

export default drawGraph