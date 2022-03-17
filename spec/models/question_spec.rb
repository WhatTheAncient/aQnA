require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'fileable'
  it_behaves_like 'commentable'

  it { should belong_to(:author) }
  it { should belong_to(:best_answer).optional }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :reward }

  describe '.set_best_answer' do
    let!(:question) { create(:question, :with_answers, best_answer: create(:answer)) }

    describe 'answer in question.answers' do
      let(:answer) { question.answers.first }
      let!(:reward) { create :reward, question: question }
      before { question.set_best_answer(answer) }

      it 'should set best answer to question' do
        expect(question.best_answer.id).to eq answer.id
      end

      it 'should set reward to answers author if it exists' do
        expect(reward.user).to eq answer.author
      end
    end

    it 'should not set best answer to question if this answer not in question.answers' do
      answer = create(:answer)
      question.set_best_answer(answer)
      expect(question.best_answer.id).to_not eq answer.id
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls Services::ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)

      question.save!
    end
  end
end
