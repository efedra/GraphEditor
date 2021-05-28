import ListStore from "../components/stores/ListStore";

require("channels");
require("../components/player/PlayerApp");

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import {PlayerApp} from '../components/player/PlayerApp';

import NodeStore from "../components/stores/NodeStore";

document.addEventListener("DOMContentLoaded",function(){
    const myStoreNode = new NodeStore();
    ReactDOM.render(<PlayerApp store = {myStoreNode}/>, document.getElementById('root'));
});

