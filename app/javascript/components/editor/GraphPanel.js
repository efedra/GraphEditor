import React from "react";
import { Graph } from "react-d3-graph";
import GraphConfig from './GraphConfig.json'
import {toast} from "react-toastify";
import {observer} from "mobx-react";

@observer class GraphPanel extends React.Component {

    //TODO переписать все методы из his.props.onChange в this.props.store
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
        if(event.type==='node') {
            this.props.onChange(event.type, event.id, event.data);
        }
        if(event.type==='link')
        {
            this.props.onChange(event.type, event.id, event.data);
        }
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
            data:  {startId: startNode,
                endId: endNode}})
    }

    onClickLink (source, target) {
        this.handleChange({
            id: this.state.graph.links.find(x=> x.source=== source && x.target=== target).id, type: 'link',
            data: this.state.graph.links.find(x => x.source === source && x.target === target)
        })
    };

     onNodePositionChange (nodeId, x, y) {
         this.handleChange({
             id: nodeId, type: 'node',
             data: {x: x, y: y}
         })
         this.props.store.MoveElementGraph(nodeId,x,y)
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





        const onRightClickLink = function(event, source, target) {
            window.alert(`Right clicked link between ${source} and ${target}`);
        };

        const onMouseOverLink = function(source, target) {
            window.alert(`Mouse over in link between ${source} and ${target}`);


        };

        const onMouseOutLink = function(source, target) {
            window.alert(`Mouse out link between ${source} and ${target}`);
        };



        return <div className="GraphPanel .flex-shrink">
            <div hidden={true}>
                {this.state.graph.clock}
            </div>
            <Graph
                id="graph-id" // id is mandatory, if no id is defined rd3g will throw an error
                data={this.state.graph}
                config={myConfig}
                onClickNode={this.onClickNode.bind(this)}
                onDoubleClickNode={this.onDoubleClickNode.bind(this)}
                //    onRightClickNode={onRightClickNode}
                //    onClickGraph={onClickGraph}
                onClickLink={this.onClickLink.bind(this)}
                //    onRightClickLink={onRightClickLink}
                // onMouseOverNode={onMouseOverNode}
                //  onMouseOutNode={onMouseOutNode}
                //   onMouseOverLink={onMouseOverLink}
                //   onMouseOutLink={onMouseOutLink}
                  onNodePositionChange={this.onNodePositionChange.bind(this)}
            />
        </div>;

    }
}

export default GraphPanel