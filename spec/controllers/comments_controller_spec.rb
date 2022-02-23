require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let!(:user) { create(:user) }
    before { login(user) }
    let!(:question) { create(:question) }
    describe 'with valid attributes' do
      it 'should increase comments count in db' do
        expect { post :create,
                      params: { comment: { body: 'Test Body' }, commentable_type: question.class.to_s, commentable_id: question.id },
                      format: :js }.to change(Comment, :count).by(1)
      end

      it 'should render :create template' do
        post :create,
             params: { comment: { body: 'Test Body' }, commentable_type: question.class.to_s, commentable_id: question.id },
             format: :js

        expect(response).to render_template :create
      end
    end

    describe 'with invalid attributes' do
      it 'should not increase comments count in db' do
        expect { post :create,
                      params: { comment: { body: ''}, commentable: Question.last },
                      format: :js }.to_not change(Comment, :count)
      end

      it 'should render :create template' do
        post :create, params: { comment: { body: ''}, commentable: Question.last }, format: :js
        expect(response).to render_template :create
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
