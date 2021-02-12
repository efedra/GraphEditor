import React from "react";
import {CompactPicker} from 'react-color';
import EditorInput from "./EditorInput";
import {element, node} from "prop-types";

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

    handleClickCreate = (event) => {
        this.props.createElement(event.type, parseInt(event.id), event.data);
    }

    handleClickDelete = () => {
        const nodeID = this.props.element.elementId;
        this.props.deleteElement('node',nodeID);
    }

    render() {
        function buildFieldSet(element, owner) {
            if (element.data !== undefined) {
                return <div>
                    {element.elementType} {element.elementId}
                    <fieldset className='pr-2 pl-2'>
                        <EditorInput legend='X' data={element.data.x} onChange={owner.handleXChange.bind(owner)}/>
                        <EditorInput legend='Y' data={element.data.y} onChange={owner.handleYChange.bind(owner)}/>
                        <EditorInput legend='Font Size' data={element.data.fontSize != null ? element.data.fontSize : 8}
                                     onChange={owner.handleFontSizeChange.bind(owner)}/>
                        <EditorInput legend='Stroke Width'
                                     data={element.data.strokeWidth != null ? element.data.strokeWidth : 1}
                                     onChange={owner.handleStrokeWidthChange.bind(owner)}/>
                        <div>
                            <legend>Color</legend>
                            <CompactPicker
                                color={element.data.color != null ? element.data.color.hex : '#fff'}
                                onChange={owner.handleColorChange.bind(owner)}/>
                        </div>
                        <div>
                            <legend>Stroke Color</legend>
                            <CompactPicker
                                color={element.data.strokeColor != null ? element.data.strokeColor.hex : '#fff'}
                                onChange={owner.handleStrokeColorChange.bind(owner)}/>
                        </div>
                    </fieldset>
                </div>
            }
        }

        return <div className='Editor'>
            <h3></h3>
            <div>
                <button
                    className='bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded'
                    onClick={this.handleClickCreate.bind(this)}>
                    Create node
                </button>
                <button
                    className='bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded ml-1'
                    onClick={this.handleClickDelete.bind(this)}>
                    Delete node
                </button>
            </div>
            {this.props.element != null &&
            buildFieldSet(this.props.element, this)
            }
        </div>;


    }


}