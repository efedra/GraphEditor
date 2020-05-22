import React, {Component} from 'react'
import ShowGraphList from "./ShowGraphList";

export default class GraphListApp extends React.Component {
    constructor(props) {
        super(props);
        this.state = {graphs: null};
    }

    updateList = (data) => {
        this.setState({graphs: data})
    }

    componentDidMount() {
        const that= this
        this.setState(fetch('/api/graphs', {method: 'get'}).then(function (response) {
            response.json().then(function (data) {
                that.setState({graphs: data});
            })

        }).catch(function (err) {
        }))
    }

    handleClickCreate = () => {
        fetch('/api', {method: 'post'}).then()
    }


    render() {
        return <div>
            <button
                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded mb-2 ml-10  mt-2 "
                onClick={this.handleClickCreate.bind(this)}>+ Create
            </button>
            <div>
                <ShowGraphList graphList={this.state.graphs} updateState={this.updateList} />
            </div>
        </div>

    }
}

