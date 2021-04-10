import consumer from "./consumer"

export function subscribeToUser(userId)
{consumer.subscriptions.create({ channel: "UsersChannel", user_id: userId}, {
    connected() {
        // Called when the subscription is ready for use on the server
        console.log('Subscribed')
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        console.log('Got some data')
        // Called when there's incoming data on the websocket for this channel
        switch(data.type) {
            default:
                console.log(`Unrecognized ${data.type}`)
        }
    }
})}
