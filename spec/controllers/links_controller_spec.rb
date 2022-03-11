require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question) { create(:question, :with_links) }

      it_behaves_like 'AJAX DELETEable' do
        let!(:author) { question.author }
        let!(:resource) { question.links.first }
        let!(:resource_collection) { question.links }
      end
    end

    context 'answer' do
      let!(:answer) { create :answer, :with_links }

      it_behaves_like 'AJAX DELETEable' do
        let!(:author) { answer.author }
        let!(:resource) { answer.links.first }
        let!(:resource_collection) { answer.links }
      end
    end
  end
end