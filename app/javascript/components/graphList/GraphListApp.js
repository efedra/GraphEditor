import React from 'react'
import {Router} from 'react-router-dom'
import {createBrowserHistory} from "history";
import {observer} from "mobx-react";
import ShowGraphList from "./ShowGraphList";


export const history = createBrowserHistory();

export const GraphListApp = observer(({store}) =>
    <Router history={history}>
            <ShowGraphList store={store}/>
    </Router>)
