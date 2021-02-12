import React from "react";
import {toast} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import GraphPanel from './GraphPanel'
import Editor from "./Editor";
import {element, elementType} from "prop-types";

toast.configure()

function xor(...arrs) {
    return arrs.reduce((acc, arr, i) => {
        var accSet = new Set(acc), // множество из элементов первого массива
            arrSet = new Set(arr); // множество из элементов второго массива
        return [...accSet].filter(a => !arrSet.has(a)) // элементы первого множества без элементо второго
            .concat( // объединение
                [...arrSet].filter(a => !accSet.has(a)) // элементы второго множества без элементов первого
            );
    }, []);
}

class EditorApp extends React.Component {

    constructor(props) {
        super(props);

        //todo get actual graph


        /* fetch('/api/graphs/'+ this.props.graph, {
             method: 'get'
         }).then(function(response) {
             response.json().then(function(data)
             {
                 component.setState({graph: data});
             })

         }).catch(function(err) {});*/

        this.state = {graph: null, selectedElement: null};
        this.handleGraphChange = this.handleGraphChange.bind(this);
        this.handleEditorChange = this.handleEditorChange.bind(this);
    }

    componentDidMount() {
        const component = this
        fetch('/new_graph', {
            method: 'get'
        }).then(function (response) {
            response.json().then(function (data) {

                /*                let d3Graph = {}
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
                                })*/
                component.setState({graph: data});
            })

        }).catch(function (err) {


        });
    }

    getSymbol(nodeType) {
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
        if (elementType === 'new_edge') {
            this.setState({
                graph: this.state.graph.links.push({
                    id: Math.max(...this.state.graph.links.map(x => x.id)) + 1,
                    source: eventData.startId, target: eventData.endId
                })
            })
            this.handleEditorChange('node', eventData.startId)
            return;
        }
        const data = this.extractEditorData(elementType, elementId);
        this.setState({
            graph: this.state.graph, element: {
                elementType: elementType, elementId: elementId, data: data
            }
        });
    }

    extractEditorData(elementType, elementId) {
        if (elementType === 'node') {
            return this.state.graph.nodes.find(x => x.id === elementId)
        } else {
            return this.state.graph.links.find(x => x.id === elementId);
        }
    }

    handleEditorChange(elementType, elementId, newElement) {

        let oldElement = this.extractEditorData(elementType, elementId);
        for (const property in newElement) oldElement[property] = newElement[property];
        this.setState({
            graph: this.state.graph, element: {
                elementType: elementType, elementId: elementId, data: oldElement
            }
        });
    }

    createElementGraph = () => {
        this.setState({
            graph: this.state.graph.nodes.push({
                id: Math.max(...this.state.graph.nodes.map(x => x.id)) + 1,
            })
        })
        this.handleEditorChange('node')
    };

    deleteElementGraph = (elementType,DeleteId) => {

        let linksToDelete =this.state.graph.links.filter(x=>x.target==DeleteId || x.source==DeleteId)

        this.setState({graph:this.state.graph.links= xor(this.state.graph.links,linksToDelete)});

        let arrayNodesToId = this.state.graph.nodes.map(x => x.id).indexOf(DeleteId);
        this.setState({graph:this.state.graph.nodes.splice(arrayNodesToId,1)})
        this.handleEditorChange(elementType,DeleteId)

    }

    render() {
        if (this.state.graph != null) {
            return (<div className='flex h-screen'>
                <div className='flex-auto flex-col sm:flex-row '>
                    <GraphPanel graph={this.state.graph}
                                onChange={this.handleGraphChange}/>
                </div>
                <div className='bg-blue-300 flex-auto flex-col sm:flex-row'>
                    <Editor element={this.state.element}
                            onChange={this.handleEditorChange}
                            graph={this.state.graph}
                            createElement={this.createElementGraph}
                            deleteElement={this.deleteElementGraph}
                    />
                </div>
            </div>);
        } else {
            return (<div></div>)
        }
    }
}


export default EditorApp;

