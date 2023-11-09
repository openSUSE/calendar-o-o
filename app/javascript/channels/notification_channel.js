import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (Notification.permission === 'granted') {
      new Notification(data.title, { body: data.description })
    }
  }
});
