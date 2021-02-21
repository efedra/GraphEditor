import React, {Component} from 'react'
import {Router, Route, Link} from 'react-router-dom'
import {createBrowserHistory} from "history";
import {observer} from "mobx-react";
import MobXShowGraphList from "./MobXShowGraphList";


export const history = createBrowserHistory();

export default @observer
class MobXGraphListApp extends React.Component {

    componentDidMount() {
        this.props.store.update()
    }

    render() {

        return (
            <Router history={history}>
                <div>
                    <MobXShowGraphList graphList={this.props.store}/>
                </div>
            </Router>

        )
    }
}