import React from "react";
import GraphPanel from '../components/GraphPanel'
import Editor from "../components/Editor";

class App extends React.Component {

    constructor(props) {
        super(props);
        const component = this;
        fetch('/random-graph', {
            method: 'get'
        }).then(function(response) {
            response.json().then(function(data)
            {
                component.setState({graph: data});
            })

        }).catch(function(err) {

        });
        this.state = {graph: null, selectedElement: null};
        this.handleGraphChange = this.handleGraphChange.bind(this);
        this.handleEditorChange = this.handleEditorChange.bind(this);
    }
    handleGraphChange(elementType, elementId) {
        const data = this.extractEditorData(elementType, elementId);
        this.setState({graph: this.state.graph, element:{
            elementType: elementType, elementId: elementId, data:this.extractEditorData(elementType, elementId)
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
    }

render() {
    if (this.state.graph != null)
    {
        return (<div className='App'>
            <div className='WorkArea'>
                <GraphPanel graph = {this.state.graph}
                            onChange = {this.handleGraphChange}/>
            </div>
            <div className='EditorArea'>
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


export default App;

