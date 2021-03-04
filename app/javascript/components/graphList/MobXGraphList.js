import React, {Component} from 'react'
import {Router, Route, Link} from 'react-router-dom'
import {createBrowserHistory} from "history";
import {observer} from "mobx-react";
import MobXShowGraphList from "./MobXShowGraphList";


export const history = createBrowserHistory();

export const MobXGraphList = observer(({ store }) => <Router history={history}>
    <div>
        <h1>{store.graphList.count}</h1>
        <MobXShowGraphList store={store}/>
    </div>
</Router>)
