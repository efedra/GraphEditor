import consumer from "./consumer"

export function subscribeToGraph(graph_id)
{consumer.subscriptions.create({ channel: "GraphsChannel", graph_id: graph_id}, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    switch(data.type) {
      case 'graph_update':
        const val = document.getElementById("graphName")
        val.innerHTML = data.data.name
        break
      default:
        console.log(`Unrecognized ${data.type}`)
    }
  }
})}
