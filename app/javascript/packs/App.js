import React from "react";
import GraphPanel from '../components/GraphPanel'
import Editor from "../components/Editor";
import GraphData from "../components/Graph1.json"
class App extends React.Component {

    constructor(props) {
        super(props);
        this.state = {graph: GraphData, selectedElement: null};
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
  return (<div className='App'>
          <div className='WorkArea'>
              <GraphPanel graph = {this.state.graph}
              onChange = {this.handleGraphChange}/>
          </div>
          <div className='EditorArea'>
              <Editor element = {this.state.selectedElement}/>
          </div>

      </div>

  );
}
}

export default App;

