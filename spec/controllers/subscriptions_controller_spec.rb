require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  before { login(user) }

  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:invalid_question) { create(:question) }

    before { create(:subscription, user: user, question: invalid_question) }

    it_behaves_like 'AJAX POSTable' do
      let!(:valid_params) { { question_id: question.id } }
      let!(:invalid_params) { { question_id: invalid_question.id } }
      let!(:resource_collection) { question.subscriptions }
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, :with_subscriptions) }

    it_behaves_like 'AJAX DELETEable' do
      let!(:resource) { question.subscriptions.first }
      let!(:author) { resource.user }
      let!(:resource_collection) { question.subscriptions }
    end
  end
end