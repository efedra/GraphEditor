import React from "react";
import State from "./State";
import {observer} from "mobx-react";
import ImageExist from "./ImageExist";


export const PlayerApp = observer(({store}) =>
    <div className='h-screen flex mb-4'>
        <div className="lg:w-3/4 flex flex-col">
            <div className=' h-full bg-white flex flex-col border-4 border-blue-600 rounded m-2'>
                <div className='flex justify-center'>
                    <ImageExist image={store.node.image}/>
                </div>
                <div className='  font-medium text-blue-600 m-2 '>
                    {store.node.text}
                </div>
            </div>
            <div className='h-64 bg-white border-4 border-blue-600 rounded m-2 '>
                    <ul>
                        {store.node.answers.map(function (answer) {
                                return (
                                    <li key={answer.id} className=" flex  m-2 bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white
                                 font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2">{answer.text}</li>
                                )
                            }
                        )}
                    </ul>
            </div>
        </div>
        <State store={store}/>
    </div>
)