import React, {Component} from 'react'
import * as d3 from "d3";

class CreateGraph extends Component {

    constructor(props) {
        super(props)
        // set up SVG for D3
        this.state = {
            width: window.innerWidth,
            height: window.innerHeight,
            radiusNode: 20,
        }
    }
    create()
    {
        d3.select("svg").remove()
    }
    render() {
    return(
        <div>
            {this.create()}
        </div>
    )

    }
}

export default CreateGraph;