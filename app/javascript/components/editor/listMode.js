import React, {Component} from 'react'
import DownloadGraph from './DownloadGraph';
import CreateGraph from "./createGraph";

class ListMode extends Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 'create'
        }
    }

    handleChange = (e) => {
        this.setState({value: e.target.value});
    }

    render() {
        if (this.state.value === 'create') {
            return (
                <form>
                    <h1> Pick function</h1>
                    <select value={this.state.value} onChange={this.handleChange}>

                        <option value="download">Download Graph</option>
                    </select>
                    <CreateGraph/>
                </form>

            )
        } else {
            return (
                <div>
                <form>
                    <h1> Pick function</h1>
                    <select value={this.state.value} onChange={this.handleChange}>
                        <option value="create">Create Graph</option>
                        <option value="download">Download Graph</option>
                    </select>
                </form>
                <DownloadGraph/>
                </div>
            )
        }

    }



}

export default ListMode