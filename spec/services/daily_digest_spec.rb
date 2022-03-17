require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }
  let!(:correct_questions) { create_list(:question, 2, created_at: 12.hours.ago, author: users.last) }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, correct_questions).and_call_original }
    subject.send_digest
  end
end
