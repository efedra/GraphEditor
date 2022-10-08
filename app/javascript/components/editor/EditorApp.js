import React from "react";
import {toast} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import GraphPanel from './GraphPanel'
import Editor from "./Editor";
import {observer} from "mobx-react"
toast.configure()

export const EditorApp = observer(({store}) => {
        if (store.graph != null) {
            return (<div className='flex h-screen'>
                <div className='flex-auto flex-col sm:flex-row '>
                    <GraphPanel graph={store.graph}
                                onChange={store.handleGraphChange}
                                store ={store}/>
                </div>
                <div className='bg-blue-300 flex-auto flex-col sm:flex-row'>
                    <Editor element={store.element}
                            onChange={store.handleEditorChange}
                            graph={store.graph}
                            createElement={store.createElementGraph}
                            deleteElement={store.deleteElementGraph}
                            store = {store}
                    />
                </div>
            </div>);
        } else {
            return (<div></div>)
        }
    }
)

