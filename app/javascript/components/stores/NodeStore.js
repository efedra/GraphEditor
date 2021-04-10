import {makeAutoObservable} from "mobx";
import arch from '../../images/arch.jpg'

export default class NodeStore {
    node= {
        id: 1,
        text: " Какой язык программированиая учить?",
        image: arch,
        kind: "start",
        answers: [
            {
                id: 1,
                text: "Ruby",
                enabled: true
            },
            {
                id: 2,
                text: "js",
                enabled: false
            },
            {
                id: 3,
                text: "C++",
                enabled: true
            },
            {
                id: 4,
                text: "C#",
                enabled: false
            }
        ],
        state: {
            hp: 100,
            money: 4343
        }
    }


    constructor() {
        makeAutoObservable(this);
    }
}