import React, {Component} from 'react'
import {ModalWindow} from "./ModalWindow";
import FormDialog from "./InviteButton";
import {observer} from "mobx-react";

@observer class ShowGraphList extends Component {


    handleClickEdit = (index) => {
        this.props.store.editGraph(index)
    }
    handleClickPlay = () => {
        this.props.store.playGraph()
    }
    handleClickInvite = () => {
        //fetch('/graph')
    }
    handleClickDelete = (index) => {
        this.props.store.delete(index)
    }

    handleClickCreate = () => {

    }


    render() {


        let that = this;
        return (
            <div>
                <ModalWindow store = {this.props}/>
                <ul>
                    {this.props.store.graphList && this.props.store.graphList.map(function (graph, index) {
                            return (
                                <li className="font-bold py-1 px-4 border border-blue-700 rounded mb-2 ml-6 mr-6 "
                                    key={index}>

                                    <div className=" text-blue-500 float-left mt-2">{index + 1})</div>
                                    <a href="/player">
                                        <button
                                            className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2"
                                            onClick={that.handleClickPlay.bind(this)}> Play
                                        </button>
                                    </a>
                                    <button
                                        className="bg-white-500 text-red-500 hover:bg-red-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1 "
                                        onClick={() => that.handleClickDelete(graph.id)}>Delete X
                                    </button>
                                    <div className=" text-blue-500 float-left mt-2">{graph.name}</div>
                                    <FormDialog/>
                                    <a href={`/editor/${graph.id}`}>
                                        <button
                                            className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1">
                                            Edit
                                        </button>
                                    </a>
                                </li>
                            )
                        }
                    )}
                </ul>
            </div>
        )
    }


}

export default ShowGraphList
