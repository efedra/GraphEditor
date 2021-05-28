require("channels")
import {subscribeToUser} from "../channels/users_channel";

import React from 'react';
import ReactDOM from 'react-dom';
import './stylesheets/index.css';


import ListStore from "../components/stores/ListStore"
import {GraphListApp} from "../components/graphList/GraphListApp";

document.addEventListener("DOMContentLoaded",function(){
    const myStore = new ListStore();
    ReactDOM.render(<GraphListApp store = {myStore}/>, document.getElementById('root'));

});
