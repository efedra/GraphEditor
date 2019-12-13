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
        colors: d3.scaleOrdinal(d3.schemeCategory10)
    }


    draw() {



        const svg = d3.select('body').append('svg').attr("width", this.state.width)
            .attr("height", this.state.height);



        const events = [];
        let that = this;
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
        });


    }



    render(){
        return(
            <div>

            </div>
        )
    }
}

export default drawGraph