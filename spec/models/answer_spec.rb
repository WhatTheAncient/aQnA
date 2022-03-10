require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'fileable'
  it_behaves_like 'commentable'

  it { should belong_to :author }
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe '.best?' do
    let(:answer) { create(:answer) }

    it 'should return false if answer is not best' do
      expect(answer).to_not be_best
    end

    it 'should return true if answer is best' do
      answer.question.update(best_answer_id: answer.id)
      expect(answer).to be_best
    end
  end
end
