import {EditorInputMultiText, EditorInputNumber, EditorInputText} from "./EditorInput";
import {CompactPicker} from "react-color";
import FileUploadButton from "./ButtonFileUpload";
import React from "react";

export default class BuildFieldSet extends React.Component { // (this.props.element, this) = element,owner

    constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
    }

    handleChange(event) {
        this.props.onChange(event.type, parseInt(event.elementId), event.data);
    }

    handleRenameNode = (Name) =>
    {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {label: Name.target.value}
        })
    }

    handleStrokeWidthChange(e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {strokeWidth: parseInt(e.target.value)}
        })
    }

    handleColorChange(color) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {color: color.hex}
        })
    }

    handleStrokeColorChange(color) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {strokeColor: color.hex}
        })
    }

    handleDescriptionChange= (Description)=>
    {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {description: Description.target.value}
        })
    }


    render() {
        if (this.props.element.data !== undefined) {
            return <div>
                <EditorInputText legend='Name of node'
                                 data={this.props.element.data.label != null ? this.props.element.data.label : this.props.element.data.id}
                                 onChange={this.handleRenameNode.bind(this)}/>
                <fieldset className='pr-2 pl-2'>
                    <EditorInputNumber legend='Stroke Width'
                                       data={this.props.element.data.strokeWidth != null ? this.props.element.data.strokeWidth : 1}
                                       onChange={this.handleStrokeWidthChange.bind(this)}/>
                    <div>
                        <legend>Color</legend>
                        <CompactPicker
                            color={this.props.element.data.color != null ? this.props.element.data.color.hex : '#fff'}
                            onChange={this.handleColorChange.bind(this)}/>
                    </div>
                    <div>
                        <legend>Stroke Color</legend>
                        <CompactPicker
                            color={this.props.element.data.strokeColor != null ? this.props.element.data.strokeColor.hex : '#fff'}
                            onChange={this.handleStrokeColorChange.bind(this)}/>
                    </div>

                    <EditorInputMultiText legend='Description of node'
                                          data={this.props.element.data.description != null ? this.props.element.data.description : ""}
                                          onChange={this.handleDescriptionChange.bind(this)}/>
                    <FileUploadButton/>

                </fieldset>
            </div>

        }else
        return(<div>

        </div>)
    }
}