import React, {Component} from 'react'


class ShowGraphList extends Component {
    constructor(props) {
        super(props);
    }

    handleClickEdit = () => {
        //fetch('/graph')
    }
    handleClickPlay = () => {
        //fetch('/graph')
    }
    handleClickInvite = () => {
        //fetch('/graph')
    }
    ClickDelete = (index) => {
        // let fun = this
        // fetch('/api/graphs/'+index, {method: 'delete'}).then(()=>{
        //         alert("Graph deleted")
        //     })

        }

    render() {
        let that = this;

        return (
            <ul>
                {this.props.graphList && this.props.graphList.map(function (graph,index) {
                        return (<li className="font-bold py-1 px-4 border border-blue-700 rounded mb-2 ml-6 mr-6 "
                            key={index}>

                            <div className=" text-blue-500 float-left mt-2">{index}) </div>
                            <button
                                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2"
                                onClick={that.handleClickPlay.bind(this)}> Play
                            </button>
                            <button
                                className="bg-white-500 text-red-500 hover:bg-red-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1 "
                                onClick={that.ClickDelete(index+1)}>Delete X
                            </button>
                                <div className=" text-blue-500 float-left mt-2">{graph.name}</div>
                            <button
                                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1"
                                onClick={that.handleClickInvite.bind(this)}>Invite
                            </button>
                            <button
                                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1 "
                                onClick={that.handleClickEdit.bind(this)}>Edit
                            </button>
                        </li>
                        )
                    }
                )}
            </ul>
        )
    }

}

export default ShowGraphList
