require 'rails_helper'

describe 'Querstions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE': 'application/json',
                    'ACCEPT': 'application/json' } }

  describe 'GET /questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like "API Unauthorizable" do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 4) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 4
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end
    end
  end
end
