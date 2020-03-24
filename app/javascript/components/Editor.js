import React from "react";

export default class Editor extends React.Component{

    constructor(props) {
        super(props);
        this.state = {element: props.element};
    }
    render()   {
        if (this.props.element != null)
        {
            return <div className='Editor'>
                {this.props.element.elementId}
            </div>;
        }
        else
        {
            return <div></div>;
        }

    }

}