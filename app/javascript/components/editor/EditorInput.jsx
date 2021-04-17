import React from "react";


export function EditorInputNumber(props) {
    return <div className=''>
                <legend>{props.legend}</legend>
                <input type="number"
                    value={props.data}
                    onChange={props.onChange}
                    className='shadow appearance-none border rounded w-full py-2 px-3
                                text-gray-700 leading-tight focus:outline-none focus:shadow-outline'/>
          </div>
}

export function EditorInputText(props) {
    return <div className='m-2'>
        <legend>{props.legend}</legend>
        <input type="text"
               value={props.data}
               onChange={props.onChange}
               className='shadow appearance-none border rounded w-full py-2 px-3
                                text-gray-700 leading-tight focus:outline-none focus:shadow-outline'/>
    </div>
}

export function EditorInputMultiText(props) {
    return <div className=''>
        <legend>{props.legend}</legend>
       <textarea rows="8" cols="20"
                 value={props.data}
                 onChange={props.onChange}
               className='shadow appearance-none border rounded w-full py-2 px-3
                                text-gray-700 leading-tight focus:outline-none focus:shadow-outline'/>
    </div>
}
