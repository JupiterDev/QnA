import consumer from "./consumer";

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // console.log("Connected");
  },

  received(data) {
    // console.log("Received");
    $(".questions").append(data);
  }
});
