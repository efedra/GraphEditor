import React from "react";
export default function EditorInput(props) {
    return <div className=''>
                <legend>{props.legend}</legend>
                <input type="number"
                    value={props.data}
                    onChange={props.onChange}
                    className='shadow appearance-none border rounded w-full py-2 px-3
                                text-gray-700 leading-tight focus:outline-none focus:shadow-outline'/>
          </div>
}