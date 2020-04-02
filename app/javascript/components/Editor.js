import React from "react";

export default class Editor extends React.Component {

    constructor(props) {
        super(props);
        this.state = {element: props.element};
        this.handleChange = this.handleChange.bind(this);

    }

    handleChange(event) {
        this.props.onChange(event.type, parseInt(event.elementId), event.data);
    }

    handleXChange(e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {x: parseInt(e.target.value)}
        })
    }

    handleYChange(e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {y: parseInt(e.target.value)}
        })
    }

    handleColorChange(e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {color: e.target.value}
        })
    }

    handleFontSizeChange(e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {fontSize: parseInt(e.target.value)}
        })
    }

    handleStrokeWidthChange(e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {strokeWidth: parseInt(e.target.value)}
        })
    }
    handleStrokeColorChange(e){
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {strokeColor: e.target.value}
        })
    }
    render() {
        function buildFieldSet(element, owner) {
            if (element.data !== undefined) {
                return <fieldset>
                    <legend>X</legend>
                    <input type="number"
                           value={element.data.y}
                           onChange={owner.handleXChange.bind(owner)}/>
                    <legend>Y</legend>
                    <input type="number"
                           value={element.data.y}
                           onChange={owner.handleYChange.bind(owner)}/>
                    <legend>Color</legend>
                    <input type="text"
                           value={element.data.color != null ? element.data.color : ""}
                           onChange={owner.handleColorChange.bind(owner)}/>
                    <legend>Font Size</legend>
                    <input type="number"
                           value={element.data.fontSize != null ? element.data.fontSize : 8}
                           onChange={owner.handleFontSizeChange.bind(owner)}/>
                    <legend>Stroke Width</legend>
                    <input type="number"
                           value={element.data.strokeWidth != null ? element.data.strokeWidth : 1}
                           onChange={owner.handleStrokeWidthChange.bind(owner)}/>
                    <legend>Stroke Color</legend>
                    <input type="text"
                           value={element.data.strokeColor != null ? element.data.strokeColor : "none"}
                           onChange={owner.handleStrokeColorChange.bind(owner)}/>
                </fieldset>
            }

        }

        if (this.props.element != null) {
            return <div className='Editor'>
                <div>{this.props.element.elementType} {this.props.element.elementId}</div>
                {buildFieldSet(this.props.element, this)}

            </div>;
        } else {
            return <div></div>;
        }

    }


}