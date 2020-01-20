import consumer from "./consumer";

$(document).on("turbolinks:load", function() {
  const questionId = $(".question").data("id");

  if (typeof questionId !== "undefined") {
    consumer.subscriptions.create("AnswersChannel", {
      connected() {
        this.perform("follow", {
          id: questionId
        });
      },
      received(data) {
        var answers = $(".answers");
        if (answers && data["answer"]["user_id"] != gon.current_user) {
          var answer = `<h4>${answer["body"]}</h4> <hr>`;
          var div = document.createElement("div");
          div.setAttribute("data-id", data["answer"]["id"]);
          div.classList.add("answer");
          div.innerHTML = answer;
          answers.append(div);
        }
      }
    });
  }
});
