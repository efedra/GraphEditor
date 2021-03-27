import React from "react";

export default function State(props) {
    return <div className='lg:w-1/4 md:w-full h-screen h-12 bg-blue-600 rounded-lg  m-2'>

                {Object.keys(props.state).map(function (key) {
                    return (
                        <div key = {key} className=' m-3 flex text-2xl font-serif text-white'>
                            <div className='w-1/4'>{key}:
                                <hr className=" mt-2"/>
                            </div>
                            <div className='w-3/4'>{props.state[key]}
                                <hr className=" mt-2" />
                            </div>
                        </div>
                    )
                })

                }
            </div>
};



