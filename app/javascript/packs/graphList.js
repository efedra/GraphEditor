require("channels")
require("./serviceWorker");
import {subscribeToGraph} from "../../javascript/channels/graphs_channel";

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import * as serviceWorker from './serviceWorker';

import ListStore from "../components/stores/ListStore"
import {GraphListApp} from "../components/graphList/GraphListApp";

document.addEventListener("DOMContentLoaded",function(){
    const myStore = new ListStore();
    ReactDOM.render(<GraphListApp store = {myStore}/>, document.getElementById('root'));
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();