import React from "react";
import { Graph } from "react-d3-graph";
import GraphSample from '../components/Graph1.json'
import GraphConfig from '../components/GraphConfig.json'
export default class GraphPanel extends React.Component {

    constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
        this.state = {graph: props.graph};

    }
    handleChange(e) {
        this.setState({graph: e.target.value});
    }
    render() {

        const myConfig = GraphConfig;

// graph event callbacks
        const onClickGraph = function() {
            window.alert(`Clicked the graph background`);
        };

        const onClickNode = function( nodeId) {
            window.alert(`Clicked node ${nodeId}`);
        };

        const onDoubleClickNode = function(nodeId) {
            window.alert(`Double clicked node ${nodeId}`);
        };

        const onRightClickNode = function(event, nodeId) {
            window.alert(`Right clicked node ${nodeId}`);
        };

        const onMouseOverNode = function(nodeId) {
            window.alert(`Mouse over node ${nodeId}`);
        };

        const onMouseOutNode = function(nodeId) {
            window.alert(`Mouse out node ${nodeId}`);
        };

        const onClickLink = function(source, target) {
            window.alert(`Clicked link between ${source} and ${target}`);
        };

        const onRightClickLink = function(event, source, target) {
            window.alert(`Right clicked link between ${source} and ${target}`);
        };

        const onMouseOverLink = function(source, target) {
            window.alert(`Mouse over in link between ${source} and ${target}`);
        };

        const onMouseOutLink = function(source, target) {
            window.alert(`Mouse out link between ${source} and ${target}`);
        };

        const onNodePositionChange = function(nodeId, x, y) {
            window.alert(`Node ${nodeId} is moved to new position. New position is x= ${x} y= ${y}`);
        };


        return <div className="GraphPanel">
            <Graph
                id="graph-id" // id is mandatory, if no id is defined rd3g will throw an error
                data={this.state.graph}
                config={myConfig}
               onClickNode={onClickNode}
            //    onDoubleClickNode={onDoubleClickNode}
            //    onRightClickNode={onRightClickNode}
            //    onClickGraph={onClickGraph}
            //    onClickLink={onClickLink}
            //    onRightClickLink={onRightClickLink}
            //   onMouseOverNode={onMouseOverNode}
            //  onMouseOutNode={onMouseOutNode}
            //   onMouseOverLink={onMouseOverLink}
            //   onMouseOutLink={onMouseOutLink}
            //  onNodePositionChange={onNodePositionChange}
            />
        </div>;

    }
}