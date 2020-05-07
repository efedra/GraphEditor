import React from "react";
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import GraphPanel from './GraphPanel'
import Editor from "./Editor";
toast.configure()
class EditorApp extends React.Component {

    constructor(props) {
        super(props);
        const component = this;
        //todo get actual graph

        fetch('/api/graphs/31', {
            method: 'get'
        }).then(function(response) {
            response.json().then(function(data)
            {

                let d3Graph = {}
                d3Graph.nodes = data.graph.nodes.map(node=>{
                    return {
                        id: node.id,
                        label: node.name,
                        x: node.html_x,
                        y: node.html_y,
                        color: node.html_color,
                        symbolType: component.getSymbol(node.kind)
                    };
                })
                d3Graph.links = data.graph.edges.map(edge=>{
                    return {
                        id: edge.id,
                        source: edge.start_id,
                        target: edge.finish_id
                    }
                })
                component.setState({graph: d3Graph});
            })

        }).catch(function(err) {

        });
        this.state = {graph: null, selectedElement: null};
        this.handleGraphChange = this.handleGraphChange.bind(this);
        this.handleEditorChange = this.handleEditorChange.bind(this);
    }

    getSymbol(nodeType)
    {
        switch (nodeType) {
            case 'start':
                return 'diamond'
            case 'finish':
                return 'star'
            default:
                return 'circle'
        }
    }
    handleGraphChange(elementType, elementId, eventData) {
        if (elementType === 'new_edge')
        {
            this.setState({graph: this.state.graph.links.push({id: Math.max(...this.state.graph.links.map(x=>x.id))+1,
                source: eventData.startId, target: eventData.endId})})
            this.handleEditorChange('node', eventData.startId)
            return;
        }
        const data = this.extractEditorData(elementType, elementId);
        this.setState({graph: this.state.graph, element:{
            elementType: elementType, elementId: elementId, data:data
            }});
    }

    extractEditorData(elementType, elementId) {
        if (elementType === 'node')
        {return this.state.graph.nodes.find(x=>x.id === elementId)}
        else
        {return this.state.graph.links.find(x=>x.id === elementId);}
    }

    handleEditorChange(elementType, elementId, newElement) {

        let oldElement = this.extractEditorData(elementType, elementId);
        for(const property in newElement) oldElement[property] = newElement[property];
        this.setState({graph: this.state.graph, element:{
                elementType: elementType, elementId: elementId, data:oldElement}});
    }

    updateGraph=(graph,elementType, elementId)=>{
        this.setState({graph:this.state.graph.nodes.push(graph)});
        this.handleEditorChange(elementType,elementId)
    };

render() {
    if (this.state.graph != null)
    {
        return (<div className='flex h-screen'>
            <div className='flex-auto flex-col sm:flex-row '>
                <GraphPanel graph = {this.state.graph}
                            onChange = {this.handleGraphChange}/>
            </div>
            <div className='bg-blue-300 flex-auto flex-col sm:flex-row' >
                <Editor element = {this.state.element}
                        onChange = {this.handleEditorChange}
                        graph = {this.state.graph}
                        update = {this.updateGraph}
                />
            </div>
        </div>);
    } else
    {
        return (<div></div>)
    }
}
}


export default EditorApp;

