import {action, makeAutoObservable} from "mobx";
import { configure } from "mobx"
import {subscribeToGraph} from "../../channels/graphs_channel";

configure({
    enforceActions: "never"
})
export default class EditorStore{
    graph =null;
    element= null;
    clock = 0;
    constructor() {
        makeAutoObservable(this)
        const component = this
        let id = document.getElementById("graph_id").textContent;

        fetch( `/api/graphs/${id}`, {
            method: 'get'
        }).then(function (response) {
            response.json().then(function (data) {
                component.graph = data;
                component.clock = data.clock
            })


        }).catch(function (err) {


        });
        this.handleGraphChange = this.handleGraphChange.bind(this);
        this.handleEditorChange = this.handleEditorChange.bind(this);
        subscribeToGraph(id, this);
    }

    handleDesync(clientTime, serverTime) {
        console.log(`Server time is ${serverTime}, client time is ${clientTime}`);
    }

    addNode(data){
        this.graph.nodes.push(data.node)
        if (this.graph.clock !== data.clock) {
            this.handleDesync(this.graph.clock, this.clock);
        }
        this.graph.clock = data.clock
     }

    handleGraphChange(elementType, elementId, eventData) {
        if (elementType === 'new_edge') {

                this.graph= this.graph.links.push({
                    id: Math.max(...this.graph.links.map(x => x.id)) + 1,
                    source: eventData.startId, target: eventData.endId
                })
            this.handleEditorChange('node', eventData.startId)
            return;
        }
        const data = this.extractEditorData(elementType, elementId);
        this.element= { elementType: elementType, elementId: elementId, data: data }



    }

    extractEditorData(elementType, elementId) {
        if (elementType === 'node') {
            return this.graph.nodes.find(x => x.id === elementId)
        } else {
            return this.graph.links.find(x => x.id === elementId);
        }


    }

    handleEditorChange(elementType, elementId, newElement) {

        let oldElement = this.extractEditorData(elementType, elementId);
        for (const property in newElement) oldElement[property] = newElement[property];
            this.element= {
                elementType: elementType, elementId: elementId, data: oldElement
            }

    }

    createElementGraph = () => {

        let that = this;
        let graphId = document.getElementById("graph_id").textContent;
        fetch(`/api/graphs/${graphId}/nodes`,
            {method:'post' , headers: {'Content-Type': 'application/json','Accept': 'application/json'},
            body:JSON.stringify({graph_id: graphId})} )
         /*   .then(function (response){
                response.json().then(function (data)
                {
                    that.graph.nodes.push(data.node)
                    that.graph.clock = data.clock
                })
            })*/
    };

    deleteElementGraph = (elementType, DeleteId) => {
        let that = this;
        this.graph.links = this.graph.links.filter(x =>  x.target !== DeleteId && x.source != DeleteId)
        let arrayNodesToId = this.graph.nodes.map(x => x.id).indexOf(DeleteId);
        this.graph.nodes.splice(arrayNodesToId, 1)
        this.graph.clock += 1;
        let graphId = document.getElementById("graph_id").textContent;

        fetch(`/api/graphs/${graphId}/nodes/${DeleteId}`,
            {method:'delete'})
            .then(function (response){
                response.json().then(function (data)
                {
                    if (that.graph.clock !== data.clock) {
                        handleDesync(that.graph.clock, data.clock);
                    }
                    that.graph.clock = data.clock
                })
            })

    }

    MoveElementGraph = (elementId, x, y) => {

        let that = this;
        let graphId = document.getElementById("graph_id").textContent; // не пост а пут
        fetch(`/api/graphs/${graphId}/nodes${elementId}`,
            {method:'post' , headers: {'Content-Type': 'application/json','Accept': 'application/json'},
                body:JSON.stringify({graph_id: graphId})} ) // id нода не нужен ток x и y
            .then(function (response){
                response.json().then(function (data)
                {
                    that.graph.nodes.push(data.node)
                    that.graph.clock = data.clock
                })
            })
    }
}