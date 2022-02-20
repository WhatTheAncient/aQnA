require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let (:question) { create(:question) }
  let (:user) { create(:user) }

  describe 'GET #index' do
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do
      login(user)
      get :show, params: { id: question }
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new link to answer.links' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns new link to question.links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns new reward to question.reward' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes'
    it 'does not save the question' do
      expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
    end
    it 're-renders new view' do
      post :create, params: { question: attributes_for(:question, :invalid) }
      expect(response).to render_template :new
    end
  end

  describe 'PATCH #update' do
    describe 'As author of question' do
      before { login(question.author) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change the question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end
        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'As not author of question' do
      it 'does not change the question' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    describe 'As author of question' do
      before { login(question.author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    describe "As not author of answer" do
      let(:user) { create(:user) }

      before { login(user) }

      it 'not deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 're-renders question page' do
        delete :destroy, params: { id: question }

        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'PATCH #choose_best_answer' do
    let!(:question) { create(:question_with_answers) }
    let!(:answer) { question.answers[4] }

    describe 'As author of question' do
      before do
        login(question.author)
        patch :choose_best_answer, params: { id: question, answer_id: answer }, format: :js
      end

      it 'assigns the chosen answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'should set question best answer' do
        question.reload
        expect(question.best_answer).to eq answer
      end
    end

    describe 'As not author of question' do
      let!(:user) { create(:user) }
      before { login(user) }

      it 'should not set question best answer' do
        patch :choose_best_answer, params: { id: question, answer_id: answer }, format: :js
        expect(question.best_answer).to_not eq answer
      end
    end
  end
end
