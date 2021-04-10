import React from "react";
import State from "../player/State";
import image from "../../images/test.jpg"

class PlayerApp extends React.Component {

    constructor(props) {
        super(props);

    }

    render() {
        return (<div className='h-screen flex mb-4'>
                <div className="lg:w-3/4 flex flex-col">
                    <div className='h-full bg-gray-500 flex flex-col justify-between'>
                        <div className='flex justify-center'>
                            <img src={image} className='max-w-sm mt-4' alt='Демо'/>
                        </div>
                       <div className='ml-4 mr-4'>
                           Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc hendrerit libero id lorem lobortis, sed gravida ex pellentesque. Nunc a elit mollis, dictum ligula a, ultricies nulla. Praesent eu rhoncus justo. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vitae pharetra quam, eu tristique arcu. Vivamus rutrum eget velit et aliquam. Fusce eu nulla tortor. Vivamus vitae ligula quam. In a ipsum ornare, aliquam nibh in, fringilla dui. Praesent aliquam finibus lorem, vel blandit tellus efficitur pharetra. Vestibulum non velit vel urna bibendum imperdiet. Phasellus pharetra eleifend lacus, et interdum leo ullamcorper vel. Duis commodo sapien vitae tincidunt dapibus. Maecenas iaculis vulputate sem, quis molestie ligula tempor nec. Aenean ut bibendum metus. Phasellus in pellentesque elit.
                       </div>
                    </div>
                    <div className='w-full h-64 bg-red-500'>
                        <div>
                            <ul>
                                <li>Вариант 1</li>
                                <li>Вариант 2</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <State state = {{'Health': 5, 'Steps':10}}>
                </State>
            </div>)
    }
}


export default PlayerApp;

