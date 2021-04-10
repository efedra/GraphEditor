import React from 'react'
import {Router} from 'react-router-dom'
import {createBrowserHistory} from "history";
import {observer} from "mobx-react";
import MobXShowGraphList from "./MobXShowGraphList";


export const history = createBrowserHistory();

export const MobXGraphList = observer(({store}) =>
    <Router history={history}>
        <div>

            <MobXShowGraphList store={store}/>
        </div>
    </Router>)
