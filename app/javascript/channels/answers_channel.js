import consumer from "./consumer"
import { answerVotesHandler } from '../utilities/votes'

$(document).on('turbolinks:load', () => {
  if ($('.answers'))
  {
    const questionId = $('.question').attr('id').split('-')[1]

    consumer.subscriptions.create("AnswersChannel", {
      connected() {
        this.perform('follow', { question_id: questionId })
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (gon.user_id != data.answer_author_id) {
          $('.answers').append(data.answer)

          if (gon.user_id == data.question_author_id) {
            $(`#answer-${data.answer_id} .choose-as-best`).removeClass('d-none')
          }

          if (gon.user_id) {
            $(`#answer-${data.answer_id} .vote-link`).removeClass('d-none')
            answerVotesHandler()
          }
        }
      }
    });
  }
})
