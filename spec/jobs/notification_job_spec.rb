require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('NotificationService') }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question) }

  before { allow(NotificationService).to receive(:new).and_return(service) }

  it 'calls NotificationService#send_new_answer' do
    expect(service).to receive(:send_new_answer)
    NotificationJob.perform_now(answer)
  end
end
