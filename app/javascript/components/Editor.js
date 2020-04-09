import React from "react";
import {CompactPicker} from 'react-color';

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

    handleColorChange(color, e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {color: color.hex}
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

    handleStrokeColorChange(color, e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {strokeColor: color.hex}
        })
    }
    handleClickCreate = ()=> {
        const NodeID= this.props.graph.nodes.length;
        this.props.update({id:NodeID,x:50,y:50},'node',NodeID) /*ВЫЗЫВАЕМ ФУНКЦИЮ КОТОРАЯ ПОДНИМАЕТ НА ВЕРХ НАШ НОЫВЙ ГРАФ*/
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
                    <CompactPicker
                        color={element.data.color != null ? element.data.color.hex : '#fff'}
                        onChange={owner.handleColorChange.bind(owner)}
                    />
                    <legend>Font Size</legend>
                    <input type="number"
                           value={element.data.fontSize != null ? element.data.fontSize : 8}
                           onChange={owner.handleFontSizeChange.bind(owner)}/>
                    <legend>Stroke Width</legend>
                    <input type="number"
                           value={element.data.strokeWidth != null ? element.data.strokeWidth : 1}
                           onChange={owner.handleStrokeWidthChange.bind(owner)}/>
                    <legend>Stroke Color</legend>
                    <CompactPicker
                        color={element.data.strokeColor != null ? element.data.strokeColor.hex : '#fff'}
                        onChange={owner.handleStrokeColorChange.bind(owner)}
                    />
                </fieldset>
            }

        }

        if (this.props.element != null) {
            return <div className='Editor'>
                <div>{this.props.element.elementType} {this.props.element.elementId}
                    <button onClick={ this.handleClickCreate} >Create node</button>
                    <button>Delete node</button>
                </div>
                {buildFieldSet(this.props.element, this)}
            </div>;
        } else {
            return <div>
                <button onClick={ this.handleClickCreate}>Create node</button>
                <button>Delete node</button>

            </div>;
        }

    }


}