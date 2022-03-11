require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let!(:user) { create(:user) }
    before { login(user) }

    context 'question' do
      let!(:question) { create(:question) }

      it_behaves_like 'AJAX POSTable' do
        let!(:valid_params) { { comment: { body: 'Test Body' },
                                commentable_type: question.class.to_s,
                                commentable_id: question.id } }
        let!(:invalid_params) { { comment: { body: nil },
                                  commentable_type: question.class.to_s,
                                  commentable_id: question.id } }
        let!(:resource_collection) { question.comments }
      end
    end

    context 'answer' do
      let!(:answer) { create(:answer) }

      it_behaves_like 'AJAX POSTable' do
        let!(:valid_params) { { comment: { body: 'Test Body' },
                                commentable_type: answer.class.to_s,
                                commentable_id: answer.id } }
        let!(:invalid_params) { { comment: { body: nil },
                                  commentable_type: answer.class.to_s,
                                  commentable_id: answer.id } }
        let!(:resource_collection) { answer.comments }
      end
    end
  end
=begin May be later
  describe 'DELETE #destroy' do
    let(:comment) { create(:comment, commentable: Answer.last) }

    describe 'as author of comment' do
      let(:author) { comment.author }
      before { login(author) }

      it 'deletes comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(Comment, :count).by(-1)
      end

      it 'renders :destroy template' do
        delete :destroy, params: { id: comment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    describe 'as not author of comment' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'does not change Comments count' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to_not change(Comment, :count)
      end

      it 'renders :destroy template' do
        delete :destroy, params: { id: comment }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
=end
end
