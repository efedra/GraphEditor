import React from "react";
import DrawGraph from '../components/DrawGraph';
import Graph from '../components/Graph.json';
import Graph1 from '../components/Graph1.json';
import ListMode from "../components/listMode";
class App extends React.Component {



render() {
  return (<div className="App">
          <ListMode />
          <DrawGraph graph={Graph1}/>
      </div>

  );
}
}

export default App;

