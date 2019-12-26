import React, {Component} from 'react'
import DrawGraph from './DrawGraph';
import Graph from '../components/Graph.json';
class ListMode  extends Component
{
    constructor(props) {
        super(props);
        this.state = {
            isCreate:false
        }
    }

    render() {


    return (
        <div>
            <select>
                <option >Create Graph</option>
                <option onClick={()=>this.getBody()} >Download Graph</option>
            </select>
        </div>
    )
    }
    getBody(){
        return <DrawGraph graph = {Graph} />
    }

}

export default ListMode