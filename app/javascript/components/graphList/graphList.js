import React, {Component} from 'react'
import ShowGraphList from "./ShowGraphList";
import {Router, Route, Link} from 'react-router-dom'
import {createBrowserHistory} from "history";
import {observable} from "mobx";

export const history = createBrowserHistory();

export default class GraphListApp extends React.Component {

    @observable listOfGraphs;

    deleteGraph = (index) => {
        const new_list = this.state.listOfGraphs.filter(x => x.id !== index)
        this.setState({listOfGraphs: new_list})
    }

    componentDidMount() {
        const that = this
        this.setState(fetch('/api/graphs', {method: 'get'}).then(function (response) {
            response.json().then(function (data) {
                that.setState({listOfGraphs: data});
            })

        }).catch(function (err) {
        }))
    }


    render() {
        return (
            <Router history={history}>
                <div>
                    <ShowGraphList graphList={this.state.listOfGraphs} deleteGraph={this.deleteGraph}/>
                </div>
            </Router>
        )
    }
}

