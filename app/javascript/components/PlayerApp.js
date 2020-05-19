import React from "react";
import State from "./player/State";

class PlayerApp extends React.Component {

    constructor(props) {
        super(props);

    }

    render() {
        return (<div className='h-screen flex mb-4'>
                <div className="lg:w-3/4 flex flex-col">
                    <div className='h-full bg-gray-500'>
                        Текст + Картинка
                    </div>
                    <div className='w-full h-64 bg-red-500'>
                        Варианты
                    </div>
                </div>
                <State state = {{'Health': 5, 'Steps':10}}>

                </State>
            </div>)
    }
}


export default PlayerApp;

