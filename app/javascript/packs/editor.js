require("channels");
require("../components/editor/DownloadGraph");
require("./serviceWorker");
require("../components/editor/EditorApp");
require("../components/editor/listMode");

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import EditorApp from '../components/editor/EditorApp';
import * as serviceWorker from './serviceWorker';

document.addEventListener("DOMContentLoaded",function(){
    ReactDOM.render(<EditorApp />, document.getElementById('root'));
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
