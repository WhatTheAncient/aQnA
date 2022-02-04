require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe '.author_of?' do
    describe 'question' do
      let (:question) { create(:question) }
      let (:user) { question.author }

      it 'should return True if user is author of resource' do
        expect(user).to be_author_of(question)
      end

      it "should return False if user isn't author of resource" do
        user = create(:user)
        expect(user).not_to be_author_of(question)
      end
    end

    describe 'answer' do
      let (:answer) { create(:answer) }
      let(:user) { answer.author }

      it 'should return True if user is author of resource' do
        expect(user).to be_author_of(answer)
      end

      it "should return False if user isn't author of resource" do
        user = create(:user)
        expect(user).not_to be_author_of(answer)
      end
    end
  end
end
