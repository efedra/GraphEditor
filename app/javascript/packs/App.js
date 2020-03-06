import React from "react";
import GraphPanel from '../components/GraphPanel'
import Editor from "../components/Editor";
class App extends React.Component {



render() {
  return (<div className='App'>
          <div className='WorkArea'>
              <GraphPanel />
          </div>
          <div className='EditorArea'>
              <Editor/>
          </div>

      </div>

  );
}
}

export default App;

