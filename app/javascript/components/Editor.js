import React from "react";

export default class Editor extends React.Component{

    constructor(props) {
        super(props);
        this.state = {element: props.element};
        this.handleChange = this.handleChange.bind(this);

    }
    handleChange(event) {
        this.props.onChange(event.type, parseInt(event.elementId), event.data);
    }

    handleXChange(e){
        this.handleChange({type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {x: parseInt(e.target.value)}})
    }
    handleYChange(e){
        this.handleChange({type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {y: parseInt(e.target.value)}})
    }
    render()   {
         function buildFieldSet(element, owner){
             if (element.data !== undefined)
             {
                 return <fieldset>
                     <legend>X</legend>
                     <input type="number"
                            value={element.data.x}
                            onChange={owner.handleXChange.bind(owner)} />
                     <legend>Y</legend>
                     <input type="number"
                            value={element.data.y}
                            onChange={owner.handleYChange.bind(owner)} />
                 </fieldset>
             }

        }
        if (this.props.element != null)
        {
            return <div className='Editor'>
                <div>{this.props.element.elementType} {this.props.element.elementId}</div>
                {buildFieldSet(this.props.element, this)}

            </div>;
        }
        else
        {
            return <div></div>;
        }

    }


}