import {makeAutoObservable} from "mobx";
import {subscribeToUser} from "../../channels/users_channel"
export default class ListStore{
    graphList = [];
    userId = null;
    constructor() {
        makeAutoObservable(this);
        const that = this;
        fetch('/api/graphs', {method: 'get'}).then(function (response) {
            response.json().then(function (data) {
                that.graphList = data.graphs;
                that.userId = data.userId;
                subscribeToUser(that.userId);
            })});
    }


    delete(index){
        let that = this;
        fetch('/api/graphs/' + index, {method: 'delete'}).then(function (response) {
            that.graphList=that.graphList.filter(x => x.id !== index)
        })

    }

    create(name)
    {
        let that = this;
        fetch('/api/graphs',{method:'post',
            headers: {'Content-Type': 'application/json','Accept': 'application/json'},
            body:JSON.stringify({graph: {name:name}}) } )
            .then(function (response){
            response.json().then(function (data)
            {
                that.graphList.push({name:data.graph.name})
            })
        })

    }

}