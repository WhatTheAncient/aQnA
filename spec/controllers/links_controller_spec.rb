require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:question) { create(:question, :with_links) }

  describe 'DELETE #destroy' do
    context 'question' do
      context 'as author' do
        let!(:author) { question.author }
        before { login(author) }

        it 'deletes file' do
          expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: question.links.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as not author' do
        let!(:user) { create(:user) }
        before { login(user) }

        it 'do not deletes file' do
          expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(question.links, :count)
        end

        it 'responses with forbidden status' do
          delete :destroy, params: { id: question.links.first }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'answer' do
      let!(:answer) { create :answer, :with_links }

      context 'as author' do
        let!(:author) { answer.author }
        before { login(author) }

        it 'deletes file' do
          expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to change(answer.links, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: answer.links.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as not author' do
        let(:user) { create(:user) }
        before { login(user) }

        it 'do not deletes file' do
          expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to_not change(answer.links, :count)
        end

        it 'responses with forbidden status' do
          delete :destroy, params: { id: answer.links.first }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end