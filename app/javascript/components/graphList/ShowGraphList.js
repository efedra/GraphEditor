import React, {Component} from 'react'
import {Route, Link} from 'react-router-dom';
import EditorApp from "../EditorApp";
import PlayerApp from "../PlayerApp";
import ModalWindow from "./ModalWindow";

class ShowGraphList extends Component {
    constructor(props) {
        super(props);
        this.state = {
            currentGraph: null,
            currentPlay: false,
            isModalOpen:false
        }
    }

    handleClickEdit = (index) => {
        this.setState({currentGraph: index})
    }
    handleClickPlay = () => {
        this.setState({currentPlay: true})
    }
    handleClickInvite = () => {
        //fetch('/graph')
    }
    ClickDelete = (index) => {
        let that = this;
        fetch('/api/graphs/' + index, {method: 'delete'}).then(function (response) {
            that.props.deleteGraph(index)
        })
    }

    handleClickCreate = () => {

    }


    render() {

       /* if(this.state.currentGraph || this.state.currentPlay) {
            return (
                <div>
                    <Route exact path="/editor" component={EditorApp}/>
                    <Route exact path="/player" component={PlayerApp}/>
                </div>

            )
        }*/
        let that = this;
        return (
                <div>
                    <ModalWindow/>
                    <ul>
                        {this.props.graphList && this.props.graphList.map(function (graph, index) {
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
                                            onClick={() => that.ClickDelete(graph.id)}>Delete X
                                        </button>
                                        <div className=" text-blue-500 float-left mt-2">{graph.name}</div>
                                        <button
                                            className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1"
                                            onClick={that.handleClickInvite.bind(this)}>Invite
                                        </button>
                                        <a href ="/editor">
                                            <button
                                                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1 "
                                                onClick={() => that.handleClickEdit(graph.id)}>Edit
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
