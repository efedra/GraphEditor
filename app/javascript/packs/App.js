import React from "react";
import GraphPanel from '../components/GraphPanel'
import Editor from "../components/Editor";

import ListMode from "../components/listMode";

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
        this.setState({graph: this.state.graph, element:{
            elementType: elementType, elementId: elementId
            }});
    }

    handleEditorChange(elementType, elementId, newElement) {
        this.state.graph =
        this.setState({scale: 'f', temperature});
    }



render() {
    if (this.state.graph != null)
    {
        return (<div className='App'>
            <ListMode />
            <div className='WorkArea'>
                <GraphPanel graph = {this.state.graph}
                            onChange = {this.handleGraphChange}/>
            </div>
            <div className='EditorArea'>
                <Editor element = {this.state.selectedElement}/>
            </div>
        </div>);
    } else
    {
        return (<div></div>)
    }
}
}

export default App;

