class NotificationMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    @user = user

    mail to:  user.email
  end
end
