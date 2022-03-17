require 'rails_helper'

RSpec.describe NotificationService do
  let(:unsubscribed_user) { create(:user) }
  let(:question) { create(:question, :with_answers) }
  let(:answer) { create(:answer, question: question) }

  it 'sends new answer to author if question and do not send it to unsubscribed user' do
    expect(NotificationMailer).to receive(:notify).with(question.author, answer).and_call_original
    expect(NotificationMailer).to_not receive(:notify).with(unsubscribed_user, answer)
    subject.send_new_answer(answer)
  end
end
