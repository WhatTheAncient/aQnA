require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted' do
    let(:resource) { create(:answer, :with_votes) }
  end

  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    let(:question) { create(:question, :with_answers) }

    context 'with valid attributes' do
      it 'saves created answer to db' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer), question_id: question } ,
               format: :js
        end.to change(question.answers, :count).by(1)
      end
      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: question },
               format: :js
        end.to_not change(question.answers, :count)
      end
      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    describe 'As author of answer' do
      before { login(answer.author) }

      it 'deletes the answer' do
        expect do
          delete :destroy,
                 params: { id: answer },
                 format: :js
        end.to change(Answer, :count).by(-1)
      end
      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    describe "As not author of answer" do
      let(:user) { create(:user) }

      before { login(user) }

      it 'not deletes the answer' do
        expect do
          delete :destroy,
                 params: { id: answer },
                 format: :js
        end.to_not change(Answer, :count)
      end

      it 'responses with forbidden status' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer) }
    let(:question) { answer.question }

    describe 'As author of answer' do
      before { login(answer.author) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          upd_answer = Answer.find(answer.id)

          expect(upd_answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

          expect(response).to render_template :update
        end

        context 'with invalid attributes' do
          it 'does not change answer attributes' do
            expect do
              patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            end.to_not change(answer, :body)
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

            expect(response).to render_template :update
          end
        end
      end
    end

    describe 'As not author of answer' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end
end
