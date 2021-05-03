import React from "react";
import { Graph } from "react-d3-graph";
import GraphConfig from './GraphConfig.json'
import {toast} from "react-toastify";
export default class GraphPanel extends React.Component {

    constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
        this.state = {graph: props.graph};

        this.selectedNode = null;
    }
    componentDidUpdate(prevProps, prevState, snapshot) {
        this.isDrawingEdge = false;
    }

    handleChange(event) {
        this.props.onChange(event.type, parseInt(event.id), event.data);
    }
     onClickNode (nodeId) {
         if (this.isDrawingEdge && this.selectedNode !== nodeId) {
             this.isDrawingEdge = false;
             this.addEdge(this.selectedNode, nodeId);
         } else {
             this.handleChange({
                 id: nodeId, type: 'node',
                 data: this.state.graph.nodes.find(x => x.id === nodeId)
             })
         }
     };

    onDoubleClickNode = function(nodeId) {
        toast('Select edge target', {position: toast.POSITION.TOP_LEFT})
        this.selectedNode = nodeId;
        this.isDrawingEdge = true;
    };
    addEdge(startNode, endNode) {
        this.handleChange({type: 'new_edge',
                data:  {startId: parseInt(startNode),
                endId: parseInt(endNode)}})
    }
    render() {

        const myConfig = GraphConfig;

// graph event callbacks
        const onClickGraph = function() {
            window.alert(`Clicked the graph background`);
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


        return <div className="GraphPanel .flex-shrink">
            <Graph
                id="graph-id" // id is mandatory, if no id is defined rd3g will throw an error
                data={this.state.graph}
                config={myConfig}
                onClickNode={this.onClickNode.bind(this)}
                onDoubleClickNode={this.onDoubleClickNode.bind(this)}
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