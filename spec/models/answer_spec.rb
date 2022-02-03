require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :author }
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe '.set_author' do
    it 'should set passed user as author of answer' do
      answer = create(:answer)
      user = create(:user)
      answer.set_author(user)

      expect(user).to be answer.author
    end
  end
end
