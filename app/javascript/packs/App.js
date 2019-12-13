import React from "react";
//import BarChart from "./components/try.js";
import DrawGraph from '../components/DrawGraph';
import Graph from '../components/Graph.json';
class App extends React.Component {

  state = {
    data: [12, 5, 6, 6, 9, 10],
    width: 700,
    height: 500,
    id: "root"
}

render() {
  return (<div className="App">
        {/*<BarChart data={this.state.data} width={this.state.width} height={this.state.height} />*/}
        <DrawGraph graph = {Graph}/>
      </div>

  );
}
}

export default App;

