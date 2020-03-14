import React, {Component} from 'react'
import * as d3 from "d3";

class downloadGraph extends Component {
    constructor(props) {
        super(props)
        // set up SVG for D3
        this.state = {
            width: window.innerWidth,
            height: window.innerHeight,
            radiusNode: 20,
        }
        this.fileInput = React.createRef();
    }

    draw(graph){
        d3.select("svg").remove()
        const svg = d3.select('body').append('svg').attr("width", this.state.width)
            .attr("height", this.state.height);
        let that = this;
        //draw Lines
        const line = svg.selectAll('line')
            .data(graph.edges)
            .enter()
            .append('line')
            .attr('x1', function (d) {
                return graph.nodes[d.from].x
            })
            .attr('y1', function (d) {
                return graph.nodes[d.from].y
            })
            .attr('x2', function (d) {
                return graph.nodes[d.to].x
            })
            .attr('y2', function (d) {
                return graph.nodes[d.to].y
            })
            .attr('stroke', 'black')
            .attr('stroke-width', 3)
            .attr('marker-end', 'url(#arrowhead)')
        //draw Circles
        const circle = svg.selectAll('circle').data(graph.nodes)
            .enter()
            .append('circle')
            .attr('cx', function (d) {
                return d.x
            })
            .attr('cy', function (d) {
                return d.y
            })
            .attr('r', that.state.radiusNode)
            .attr('fill', 'green')
            .attr('stroke', 'black')
            .attr('stroke-width', 2)

        const Text = svg.selectAll('text')
            .data(graph.nodes)
            .enter()
            .append('text')
            .attr('x', function (d) {
                return d.x
            })
            .attr('y', function (d) {
                return d.y
            })
            .text(function (d) {
                return d.text
            })
            .attr("text-anchor", "middle")

        const markerLines = svg.append('defs')
            .append('marker')
            .attr('id', 'arrowhead')
            .attr('markerWidth', 20)
            .attr('markerHeight', 12)
            .attr('refX', 12)
            .attr('refY', 3.5)
            .attr('orient', 'auto')
            .append("polygon").attr("points", "0 0, 6 3.5, 0 6");
    }


    loadFile(graph) {
            let that=this
        if (graph) {
            const reader = new FileReader();
            reader.readAsText(graph, "UTF-8");
            reader.onload = function (evt) {
                that.draw(JSON.parse(evt.target.result))

            }
            reader.onerror = function (evt) {
                console.log( "error reading file");
            }
        }


    }


    handleSubmit=(event)=> {
        event.preventDefault();
            this.loadFile( this.fileInput.current.files[0])
        
    }

    render() {
        return (
                <form onSubmit={this.handleSubmit}>
                    <label>
                        Upload file:
                        <input type="file" ref={this.fileInput} />
                    </label>
                    <br />
                    <button type="submit">Submit</button>
                </form>

        )
    }


}

export default downloadGraph