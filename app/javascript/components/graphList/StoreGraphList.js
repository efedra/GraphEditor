import {makeAutoObservable} from "mobx";

class StoreGraphList{

    constructor() {
        makeAutoObservable(this)
    }
    listOfGraphs= null;
}

export default new StoreGraphList();