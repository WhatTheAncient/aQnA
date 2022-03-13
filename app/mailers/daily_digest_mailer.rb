class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @user = user
    @questions = questions

    mail to: user.email
  end
end
