import {makeAutoObservable} from "mobx";

export default class ListStore{
    graphList = [];

    constructor() {
        makeAutoObservable(this);
        const that = this;
        fetch('/api/graphs', {method: 'get'}).then(function (response) {
            response.json().then(function (data) {
                that.graphList = data;
            })});
    }

    delete(index){
        let that = this;
        fetch('/api/graphs/' + index, {method: 'delete'}).then(function (response) {
            that.graphList=that.graphList.filter(x => x.id !== index)
        })

    }
}