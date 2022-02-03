require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    let(:question) { create(:question_with_answers) }

    context 'with valid attributes' do
      it 'saves created answer to db' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end
      it 're-render questions' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(response).to have_http_status(:found)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(question.answers, :count)
      end
      it 're-renders questions' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
