require("channels");
require("./serviceWorker");
require("../components/editor/PlayerApp");
require("../components/editor/listMode");

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import PlayerApp from '../components/editor/PlayerApp';
import * as serviceWorker from './serviceWorker';

document.addEventListener("DOMContentLoaded",function(){
    ReactDOM.render(<PlayerApp />, document.getElementById('root'));
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();