class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NotificationService.new.send_new_answer(answer)
  end
end
