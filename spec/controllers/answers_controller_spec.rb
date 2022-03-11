require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted' do
    let(:resource) { create(:answer, :with_votes) }
  end

  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    let!(:question) { create(:question, :with_answers) }

    it_behaves_like 'AJAX POSTable' do
      let!(:valid_params) { { answer: attributes_for(:answer), question_id: question } }
      let!(:invalid_params) { { answer: attributes_for(:answer, :invalid), question_id: question } }
      let!(:resource_collection) { question.answers }
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    it_behaves_like 'AJAX DELETEable' do
      let!(:author) { answer.author }
      let!(:resource) { answer }
      let!(:resource_collection) { Answer }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'AJAX PATCHable' do
      let!(:resource) { create(:answer) }
      let!(:new_attributes) { attributes_for(:answer, question: resource.question, author: resource.author) }
      let!(:old_attributes) { resource.attributes }
      let!(:valid_params) { { id: resource, answer: new_attributes } }
      let!(:invalid_params) { { id: resource, answer: attributes_for(:answer, :invalid) } }
    end
  end
end
