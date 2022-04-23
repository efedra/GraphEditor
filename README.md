# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

___

# Graph in JSON

```azure
    {
        "nodes": [
            {
                "id": 0, //Identifier
                "x": 646, // Node x coordinates
                "y": 122, // Node y coordinates
                "label": "Start", // Mark the start graph's 
                "symbolType": "diamond", // Shape node's
                "color": "red" // Color node's
            },
            {"id":1,"x":453,"y":743},
            {"id":2,"x":410,"y":412},
            {"id":3,"x":754,"y":131},
            {"id":4,"x":102,"y":407},
            {"id":5,"x":488,"y":595},
            {"id":6,"x":578,"y":373},
            {"id":7,"x":587,"y":499},
            {"id":8,"x":142,"y":279},
            {
                "id": 9,
                "x": 775,
                "y": 103,
                "label": "Finish", // Mark the finish graph's
                "symbolType": "star",
                "color": "yellow"},
            {"id":10,"x":13,"y":494}
        ],
        "links": [
            {
                "id": 0, // Identifier
                "source": 3, // From which node the link starts
                "target": 5 // To which node the link finishes
            },
            {
                "id":1,
                "source":1,
                "target":2
            },
            {"id":3,"source":4,"target":5},
            {"id":7,"source":7,"target":8},
            {"id":8,"source":10,"target":6},
            {"id":10,"source":0,"target":1},
            {"id":15,"source":6,"target":8}
        ]
    }
```
