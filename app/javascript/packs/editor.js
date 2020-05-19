require("channels");
require("../components/DownloadGraph");
require("./serviceWorker");
require("../components/EditorApp");
require("../components/listMode");

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import EditorApp from '../components/EditorApp';
import * as serviceWorker from './serviceWorker';

document.addEventListener("DOMContentLoaded",function(){
    ReactDOM.render(<EditorApp />, document.getElementById('root'));
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
