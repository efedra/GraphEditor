import React from "react";
import BuildFieldSet from "./BuildFieldSet";
import {observer} from "mobx-react";
import {action} from "mobx";

@observer class Editor extends React.Component {

    constructor(props) {
        super(props);
        this.state = {element: props.element};
        this.state = {inputValue: ''};
        this.handleChange = this.handleChange.bind(this);
    }

    handleChange(event) {
        this.props.onChange(event.type, parseInt(event.elementId), event.data);
    }


    handleClickCreate = (event) => {
        this.props.createElement(event.type, parseInt(event.id), event.data);
    }

    handleClickDelete = () => {
        const nodeID = this.props.element.elementId;
        this.props.deleteElement('node',nodeID);
    }



    render() {

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
            <BuildFieldSet element={this.props.element} onChange={this.props.onChange}/>
            }

        </div>;


    }


}

export default Editor