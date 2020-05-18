import React from "react";

export default function State(props) {
    return <div className='lg:w-1/4 md:w-full h-screen h-12 bg-blue-300'>
                {Object.keys(props.state).map(function (key) {
                    return (
                        <div key = {key} className='ml-4 mr-4 flex text-2xl font-serif'>
                            <div className='w-1/4'>{key}:</div>
                            <div className='w-3/4'>{props.state[key]}</div>
                        </div>)
                             })
                }
            </div>
};

