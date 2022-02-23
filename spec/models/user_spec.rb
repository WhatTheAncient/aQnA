require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe '.author_of?' do
    context 'question' do
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

    context 'answer' do
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

  describe '.voted_for?' do
    context 'question' do
      let(:question) { create(:question) }
      let(:vote) { create(:vote_for_question, votable: question) }
      let(:user) { vote.user }

      it 'should return True if user voted for question' do
        expect(user).to be_voted_for(question)
      end

      it "should return False if user does not vote" do
        user = create(:user)
        expect(user).not_to be_voted_for(question)
      end
    end

    context 'answer' do
      let(:answer) { create(:answer) }
      let(:vote) { create(:vote_for_answer, votable: answer) }
      let(:user) { vote.user }

      it 'should return True if user voted for answer' do
        expect(user).to be_voted_for(answer)
      end

      it "should return False if user does not vote for answer" do
        user = create(:user)
        expect(user).not_to be_voted_for(answer)
      end
    end
  end

  describe '.vote_for' do
    context 'question' do
      let(:question) { create(:question) }
      let(:vote) { create(:vote_for_question, votable: question) }
      let(:user) { vote.user }

      it "should return user's vote for question" do
        expect(user.vote_for(question)).to eq vote
      end

      it "should return nil if user does not vote for question" do
        user = create(:user)
        expect(user.vote_for(question)).to eq nil
      end
    end

    context 'answer' do
      let(:answer) { create(:answer) }
      let(:vote) { create(:vote_for_answer, votable: answer) }
      let(:user) { vote.user }

      it "should return user's vote for answer" do
        expect(user.vote_for(answer)).to eq vote
      end

      it "should return nil if user does not vote for answer" do
        user = create(:user)
        expect(user.vote_for(answer)).to eq nil
      end
    end
  end
end
