require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain')}

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question) { create :question, files: [file] }

      context 'as author' do
        let!(:author) { question.author }
        before { login(author) }

        it 'deletes file' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as not author' do
        let!(:user) { create(:user) }
        before { login(user) }

        it 'do not deletes file' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        end

        it 'redirects to root_path' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'answer' do
      let!(:answer) { create :answer, files: [file] }
      let!(:author) { answer.author }

      context 'as author' do
        let!(:author) { answer.author }
        before { login(author) }

        it 'deletes file' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as not author' do
        let(:user) { create(:user) }
        before { login(user) }

        it 'do not deletes file' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
        end

        it 'redirects to root path' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end