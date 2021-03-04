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
}