import React, {Component} from 'react'
import DrawGraph from './DrawGraph';
import Graph from '../components/Graph.json';
class ListMode  extends Component
{
    constructor(props) {
        super(props);
        this.state = {
            value:'create'
        }
    }

    handleChange = (e)=>{
        this.setState({value:e.target.value});
    }
    render() {
    return (
        <form >
            <h1> Pick function</h1>
             <select value={this.state.value} onChange={this.handleChange}>
                <option value="create" >Create Graph</option>
                <option value="download" >Download Graph</option>
             </select>

            <DrawGraph mode ={this.state.value} graph = {Graph}/>
        </form>

    )
    }

}

export default ListMode