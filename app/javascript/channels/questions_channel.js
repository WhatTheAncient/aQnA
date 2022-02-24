import consumer from "./consumer"
import { questionVotesHandler } from "../utilities/votes";

$(document).on('turbolinks:load', () => {
  consumer.subscriptions.create('QuestionsChannel', {
    connected() {
      this.perform('follow')
    },

    received(data) {
      $('.questions').append(data.question)

      if (gon.user_id) {
        $(`#question-${data.question_id} .vote-link`).removeClass('d-none')
        questionVotesHandler()
      }
    }
  })
})
