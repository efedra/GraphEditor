import EditorStore from "../components/stores/EditorStore";
import {EditorApp} from "../components/editor/EditorApp"
require("channels");
require("../components/editor/EditorApp");

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';

document.addEventListener("DOMContentLoaded",function(){
    const editorStore = new EditorStore()
    ReactDOM.render(<EditorApp store={editorStore}/>, document.getElementById('root'));
});

