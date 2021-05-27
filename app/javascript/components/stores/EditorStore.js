import {makeAutoObservable} from "mobx";
export default class EditorStore{
    graph =null;
    element= null;
    constructor() {
        makeAutoObservable(this)
        const component = this
        let id = document.getElementById("graph_id").textContent;
        fetch( '/new_graph', { //'/api/graphs/'.concat(id) // '/new_graph'
            method: 'get'
        }).then(function (response) {
            response.json().then(function (data) {
                component.graph=data;
            })


        }).catch(function (err) {


        });
        this.handleGraphChange = this.handleGraphChange.bind(this);
        this.handleEditorChange = this.handleEditorChange.bind(this);

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

        /*let that = this;
        let id = document.getElementById("graph_id").textContent;
        fetch('/api/graphs/'.concat(id),{method:'post' , headers: {'Content-Type': 'application/json','Accept': 'application/json'},
            body:JSON.stringify(this.graph)} )
            .then(function (response){
                response.json().then(function (data)
                {
                })
            })*/


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
            this.graph.nodes.push({
                id: Math.max(...this.graph.nodes.map(x => x.id)) + 1,
            })

        this.handleEditorChange('node')
    };

    deleteElementGraph = (elementType, DeleteId) => {
        this.graph.links = this.graph.links.filter(x =>  x.target !== DeleteId && x.source != DeleteId)
        let arrayNodesToId = this.graph.nodes.map(x => x.id).indexOf(DeleteId);
        this.graph.nodes.splice(arrayNodesToId, 1)
        this.handleEditorChange(elementType, DeleteId)
    }

}