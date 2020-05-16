import React, {Component} from 'react'

const graph1 = {
    nodes: [
        {
            id:"0",
            x:300,
            y:500,
            color:"red",
            size:300
        },
        {
            id:"1",
            x:600,
            y:780,
            color:"red",
            size:300
        }
    ],
    links:[
        {
            id:"0",
            source:1,
            target:2
        }
    ]
}
const graph2 = {
    nodes: [
        {
            id:"0",
            x:300,
            y:500,
            color:"red",
            size:300
        },
        {
            id:"1",
            x:600,
            y:780,
            color:"red",
            size:300
        },
        {
            id:"2",
            x:1000,
            y:780,
            color:"green",
            size:250
        }
    ],
    links:[
        {
            id:"0",
            source:1,
            target:2
        }
    ]
}
const graphsList = [graph1,graph2]
export default class GraphListApp extends React.Component{
    constructor(props)
    {
        super(props);
    }

    handleClickCreate = ()=> {
        //fetch('/graph')
    }


    render() {
        return <div>
            <button className='bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded'
                    onClick={this.handleClickCreate.bind(this)} >+ Create </button>

          <div>  </div>
        </div>
    }
}