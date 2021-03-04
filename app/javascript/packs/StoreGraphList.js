import React from "react";
import {observable, makeAutoObservable, action} from "mobx";

class Store {
    listOfGraphs = [{id: 99, name: "Not a real graph"}];
    currentGraph = null;
    currentPlay = false;
    isModalOpen = false;
    count = 0;

    constructor() {
        makeAutoObservable(this);
    }
 /*   listOfGraphs = observable(null)
    currentGraph = observable(null)
    currentPlay = observable(false)
    isModalOpen = observable(false)*/

    @action delete(index) {

        let that = this;
        fetch('/api/graphs/' + index, {method: 'delete'}).then(function (response) {
            //that.props.deleteGraph(index)
            const new_list = that.listOfGraphs.filter(x => x.id !== index)
           that.setGraph(new_list)
        })

        /*const new_list = this.state.listOfGraphs.filter(x => x.id !== index)
        this.setState({listOfGraphs: new_list})*/
    }

    @action.bound update() {

        let that = this;
        this.listOfGraphs = fetch('/api/graphs', {method: 'get'}).then(function (response) {
            response.json().then(function (data) {
                that.listOfGraphs = data;
                console.log(data);
            })

        })
    }

    @action setGraph(data) {
        this.listOfGraphs = data
    }

    @action editGraph(index){
        this.currentGraph=index
    }
    @action playGraph(){
        this.currentPlay=true;
    }

    increaseCount() {
        this.count += 1;
    }


}

export default Store


