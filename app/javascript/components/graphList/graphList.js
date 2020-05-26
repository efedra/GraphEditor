import React, {Component} from 'react'
import ShowGraphList from "./ShowGraphList";
import {Router, Route, Link} from 'react-router-dom'
import {createBrowserHistory} from "history";

export const history = createBrowserHistory();

export default class GraphListApp extends React.Component {
    constructor(props) {
        super(props);
        this.state = {graphs: null};
    }

    deleteGraph = (index) => {
         const new_list =  this.state.graphs.filter(x => x.id !== index)
         this.setState({graphs: new_list})
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



    render() {
        return (
            <Router history={history}>

            <div>
                <ShowGraphList graphList={this.state.graphs} deleteGraph={this.deleteGraph} />
            </div>

        </Router>
        )
    }
}

