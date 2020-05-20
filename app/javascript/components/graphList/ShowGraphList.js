import React, {Component} from 'react'


class ShowGraphList extends Component {


    handleClickEdit = () => {
        //fetch('/graph')
    }
    handleClickPlay = () => {
        //fetch('/graph')
    }
    handleClickInvite = () => {
        //fetch('/graph')
    }
    handleClickDelete = () => {
        //fetch('/graph')
    }

    render() {
        return (
            <ul>
                {this.props.graphList.map((graph) => <li
                        className="font-bold py-1 px-4 border border-blue-700 rounded mb-2 ml-6 mr-6 "
                        key={graph.id}>
                        <div className= " text-blue-500 float-left mt-2">{graph.id}</div>

                        <button
                            className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2"
                            onClick={this.handleClickPlay.bind(this)}> Play
                        </button>
                        <button
                            className="bg-white-500 text-red-500 hover:bg-red-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1 "
                            onClick={this.handleClickDelete.bind(this)}>Delete X
                        </button>
                        <button
                            className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1"
                            onClick={this.handleClickInvite.bind(this)}>Invite
                        </button>
                        <button
                            className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1 "
                            onClick={this.handleClickEdit.bind(this)}>Edit
                        </button>


                    </li>
                )}

            </ul>
        )
    }

}

export default ShowGraphList
