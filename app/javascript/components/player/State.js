import React from "react";
import {observer} from "mobx-react";

@observer class State extends React.Component{

    render() {
        const that = this
        return <div className='lg:w-1/4 md:w-full h-screen h-12 bg-blue-600 rounded-lg  m-2'>

            {this.props.store.node.state && Object.keys(this.props.store.node.state).map(function (key) {
                return (
                    <div key={key} className=' m-3 flex text-2xl font-serif text-white'>

                        <div className='w-1/4'>{key}:
                            <hr className=" mt-2"/>
                        </div>
                        <div className='w-3/4 text-right'>{that.props.store.node.state[key]}
                            <hr className=" mt-2"/>
                        </div>
                    </div>
                )
            })

            }
        </div>
    }

};

export default State

