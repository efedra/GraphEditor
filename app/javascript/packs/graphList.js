require("channels")
require("./serviceWorker");
import {subscribeToUser} from "../channels/users_channel";

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import * as serviceWorker from './serviceWorker';

import ListStore from "../components/graph2/ListStore"
import {MobXGraphList} from "../components/graphList/MobXGraphList";
import { configure } from "mobx"

configure({
    enforceActions: "never",
});

document.addEventListener("DOMContentLoaded",function(){
    const myStore = new ListStore();
    ReactDOM.render(<MobXGraphList store = {myStore}/>, document.getElementById('root'));

});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();