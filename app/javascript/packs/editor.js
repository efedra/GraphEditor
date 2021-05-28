import EditorStore from "../components/stores/EditorStore";
import {EditorApp} from "../components/editor/EditorApp"
require("channels");
require("./serviceWorker");
require("../components/editor/EditorApp");

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';
import * as serviceWorker from './serviceWorker';

document.addEventListener("DOMContentLoaded",function(){
    const editorStore = new EditorStore()
    ReactDOM.render(<EditorApp store={editorStore}/>, document.getElementById('root'));
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
