import ListStore from "../components/stores/ListStore";

require("channels");
require("./serviceWorker");
require("../components/player/PlayerApp");

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import {PlayerApp} from '../components/player/PlayerApp';
import * as serviceWorker from './serviceWorker';
import NodeStore from "../components/stores/NodeStore";

document.addEventListener("DOMContentLoaded",function(){
    const myStoreNode = new NodeStore();
    ReactDOM.render(<PlayerApp store = {myStoreNode}/>, document.getElementById('root'));
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();