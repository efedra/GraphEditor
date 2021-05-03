import React, { Component } from "react";

 export default class FileUploadButton extends Component {
    handleFileUpload = event => {
        console.log(event.target.files[0].name);
    };

    render() {
        return (
            <React.Fragment>
                <input
                    ref="fileInput"
                    onChange={this.handleFileUpload}
                    type="file"
                    style={{ display: "none" }}
                    // multiple={false}
                />
                <button
                    className="m-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded ml-1 inline-flex items-center"
                    onClick={() => this.refs.fileInput.click()}>Upload File
                    <svg className="w-4 h-4 mr-2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                        <path d="M13 8V2H7v6H2l8 8 8-8h-5zM0 18h20v2H0v-2z" stroke="white" fill="white"/>
                    </svg>
                </button>
            </React.Fragment>
        );
    }
}