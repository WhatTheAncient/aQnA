require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:created_questions).dependent(:destroy) }

  describe '.author_of?' do
    let (:question) { create(:question) }

    it 'should return True if user is author of resource' do
      expect(question.author.author_of?(question)).to be true
    end

    it "should return False if user isn't author of resource" do
      user = create(:user)
      expect(user.author_of?(question)).to be false
    end
  end
end
