import React from "react";
import {CompactPicker} from 'react-color';
import {EditorInputNumber} from "./EditorInput";
import {EditorInputText} from "./EditorInput";



export default class Editor extends React.Component {

    constructor(props) {
        super(props);
        this.state = {element: props.element};
        this.state = {inputValue: ''};
        this.handleChange = this.handleChange.bind(this);
    }

    handleChange(event) {
        this.props.onChange(event.type, parseInt(event.elementId), event.data);
    }


    handleColorChange(color) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {color: color.hex}
        })
    }


    handleStrokeWidthChange(e) {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {strokeWidth: parseInt(e.target.value)}
        })
    }

    handleStrokeColorChange(color) {
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

    handleRenameNode = (Name) =>
    {
        this.handleChange({
            type: this.props.element.elementType, elementId: this.props.element.elementId,
            data: {label: Name.target.value}
        })
    }



    render() {
        function buildFieldSet(element, owner) {
            if (element.data !== undefined) {
                return <div>
                   <EditorInputText legend='Name of Node' data={element.data.label!=null ?element.data.label : element.data.id}
                    onChange={owner.handleRenameNode.bind(owner)}/>
                    <fieldset className='pr-2 pl-2'>
                        <EditorInputNumber legend='Stroke Width'
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

                        <button
                            className="m-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded ml-1 inline-flex items-center"
                            onClick={()=> owner.handleUploadFile.bind(owner)}>
                            <svg className="w-4 h-4 mr-2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                                <path d="M13 8V2H7v6H2l8 8 8-8h-5zM0 18h20v2H0v-2z" stroke="white" fill="white"/>
                            </svg>
                            <span>Upload</span>
                            <input type='file' id='file'  style={{display: 'none'}}/>
                        </button>

                    </fieldset>
                </div>
            }
        }

        return <div className='Editor'>
            <div>
                <button
                    className='m-3 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded'
                    onClick={this.handleClickCreate.bind(this)}>
                    Create node
                </button>
                <button
                    className='m-3 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded ml-1'
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