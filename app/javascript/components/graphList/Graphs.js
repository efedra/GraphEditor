const graph1 = {
    data: [
        {
            nodes: [
                {
                    id: "0",
                    x: 300,
                    y: 500,
                    color: "red",
                    size: 300
                },
                {
                    id: "1",
                    x: 600,
                    y: 780,
                    color: "red",
                    size: 300
                }
            ],
            links: [
                {
                    id: "0",
                    source: 1,
                    target: 2
                }
            ]
        }
    ],
    id:1
}
const graph2 = {
    data:[{
        nodes: [
            {
                id: "0",
                x: 300,
                y: 500,
                color: "red",
                size: 300
            },
            {
                id: "1",
                x: 600,
                y: 780,
                color: "red",
                size: 300
            },
            {
                id: "2",
                x: 1000,
                y: 780,
                color: "green",
                size: 250
            }
        ],
        links: [
            {
                id: "0",
                source: 1,
                target: 2
            }
        ]
    }],
    id:2
}
export  const listOfGraph =[graph1,graph2]
