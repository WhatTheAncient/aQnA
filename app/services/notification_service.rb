class NotificationService
  def send_new_answer(answer)
    answer.question.subscriptions.includes(:user).each do |subscription|
      NotificationMailer.notify(subscription.user, answer).deliver_later
    end
  end
end
