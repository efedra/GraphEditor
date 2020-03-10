import React from "react";

export default class Editor extends React.Component{

    constructor(props) {
        super(props);


    }
    render()   {
        const selectedElement = this.props.temperature;
        const scale = this.props.scale;
        return <div className='Editor'>
            {this.props.text}
        </div>;
    }

}