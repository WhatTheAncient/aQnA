import consumer from "./consumer"
$(document).on('turbolinks:load', () => {
  consumer.subscriptions.create("CommentsChannel", {
    connected() {
      this.perform('follow')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      $(`#${data.commentable_type}-${data.commentable_id} .comments .list-inline`).append(data.comment)
    }
  });

})
