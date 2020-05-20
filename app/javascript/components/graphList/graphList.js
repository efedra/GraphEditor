import React, {Component} from 'react'
import {listOfGraph} from "./Graphs";
import ShowGraphList from "./ShowGraphList";


export default class GraphListApp extends React.Component {
    constructor(props) {
        super(props);
    }

    handleClickCreate = () => {
        //fetch('/graph')
    }


    render() {
        return <div>
            <button
                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded mb-2 ml-10  mt-2 "
                onClick={this.handleClickCreate.bind(this)}>+ Create
            </button>

            <div>
                <ShowGraphList  graphList={listOfGraph}/>
            </div>
        </div>
    }
}

