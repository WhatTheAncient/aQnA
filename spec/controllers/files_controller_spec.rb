require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain')}

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question) { create :question, files: [file] }

      it_behaves_like 'AJAX DELETEable' do
        let!(:author) { question.author }
        let!(:resource) { question.files.first }
        let!(:resource_collection) { question.files }
      end
    end

    context 'answer' do
      let!(:answer) { create :answer, files: [file] }

      it_behaves_like 'AJAX DELETEable' do
        let!(:author) { answer.author }
        let!(:resource) { answer.files.first }
        let!(:resource_collection) { answer.files }
      end
    end
  end
end