import React from "react";


export default function ImageExist(props){
    if(props.image)
        return <img src={props.image} className='max-w-xs max-h-52 mt-4 border-4 border-blue-600 rounded' alt='Demo'/>
    else return <div></div>
}