import React from "react";
import State from "./State";
import cat from '../../images/cat.jpg'
import image from '../../images/image.jpeg'
import arch from '../../images/arch.jpg'

class PlayerApp extends React.Component {

    constructor(props) {
        super(props);

    }

    render() {
        return (
            <div className='h-screen flex mb-4'>
                <div className="lg:w-3/4 flex flex-col">
                    <div className=' h-full bg-white flex flex-col border-4 border-blue-600 rounded m-2'>
                        <div className='flex justify-center'>
                            <img src={arch} className='max-w-xs max-h-52 mt-4 border-4 border-blue-600 rounded' alt='Демо'/>
                        </div>
                        <div className='  font-medium text-blue-600 m-2 '>
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc hendrerit libero id lorem
                            lobortis, sed gravida ex pellentesque. Nunc a elit mollis, dictum ligula a, ultricies nulla.
                            Praesent eu rhoncus justo. Orci varius natoque penatibus et magnis dis parturient montes,
                            nascetur ridiculus mus. Vivamus vitae pharetra quam, eu tristique arcu. Vivamus rutrum eget
                            velit et aliquam. Fusce eu nulla tortor. Vivamus vitae ligula quam. In a ipsum ornare,
                            aliquam nibh in, fringilla dui. Praesent aliquam finibus lorem, vel blandit tellus efficitur
                            pharetra. Vestibulum non velit vel urna bibendum imperdiet. Phasellus pharetra eleifend
                            lacus, et interdum leo ullamcorper vel. Duis commodo sapien vitae tincidunt dapibus.
                            Maecenas iaculis vulputate sem, quis molestie ligula tempor nec. Aenean ut bibendum metus.
                            Phasellus in pellentesque elit.
                        </div>
                    </div>
                    <div className='h-64 bg-white border-4 border-blue-600 rounded m-2 '>
                        <div >
                            <ul>
                                <li className=" flex  m-2 bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white
                                 font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2">Вариант 1</li>
                                <li className=" flex  m-2 bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white
                                 font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2">Вариант 2</li>
                                <li className=" flex m-2 bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white
                                font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2">Вариант 3</li>
                                <li className=" flex  m-2 bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white
                                font-bold py-2 px-4 border border-blue-700 rounded ml-3 mr-2" >Очень-очень долгий вариант ответа 4</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <State state={{'Health': 5, 'Steps': 10, 'Money': 254}}>
                </State>
            </div>)
    }


}


export default PlayerApp;

