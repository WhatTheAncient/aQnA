require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT': 'application/json' } }

  describe 'GET /question/:question_id/answers' do
    let(:question) { create(:question, :with_answers) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 5
      end

      it_behaves_like 'public fields returned' do
        let(:public_fields) { %w[id body rating best? rating created_at updated_at] }
        let(:resource) { answer }
        let(:resource_response) { answer_response }
      end

      it 'contains author object' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end
    end
  end

  describe 'GET /answers/:id' do
    let(:answer) { create(:answer, :with_files, :with_links, :with_comments) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'public fields returned' do
        let(:public_fields) { %w[id body rating best? created_at updated_at] }
        let(:resource) { answer }
        let(:resource_response) { json['answer'] }
      end

      it_behaves_like 'API list returnable' do
        let(:resource_associations) { %w[links files comments] }
        let(:resource) { answer }
        let(:resource_response) { json['answer'] }
      end

      context 'links' do
        it_behaves_like 'public fields returned' do
          let(:public_fields) { %w[id name url created_at updated_at] }
          let(:resource) { answer.links.first }
          let(:resource_response) { json['answer']['links'].first }
        end
      end

      context 'files' do
        it 'returns file url' do
          expect(json['answer']['files'].first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(
            answer.files.first, only_path: true
          )
        end
      end

      context 'comments' do
        it_behaves_like 'public fields returned' do
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource) { answer.comments.first }
          let(:resource_response) { json['answer']['comments'].first }
        end
      end

      it 'contains author object' do
        expect(json['answer']['author']['id']).to eq answer.author.id
      end
    end
  end

  describe 'POST /questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }

    it_behaves_like "API Authorizable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'API POSTable' do
        let(:resource_class) { Answer }
        let(:resource) { attributes_for(:answer, author: user) }
        let(:valid_params) { { access_token: access_token.token, answer: resource } }
        let(:invalid_params) { { access_token: access_token.token, answer: attributes_for(:answer, :invalid) } }
      end
    end
  end

  describe 'PATCH /answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:old_answer_body) { answer.body }

      context 'as author' do
        let(:user) { answer.author }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        context 'with valid attributes' do
          before do
            patch api_path,
                  params: { access_token: access_token.token, answer: { body: 'new body' } },
                  headers: headers
          end

          let(:answer_response) { json['answer'] }

          it 'updates answer attributes in database' do
            answer.reload

            expect(answer.body).to eq 'new body'
          end

          it 'contains author object' do
            expect(answer_response['author']['id']).to eq access_token.resource_owner_id
          end
        end

        context 'with invalid attributes' do
          before do
            patch api_path,
                  params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) },
                  headers: headers
          end

          it 'does not change the answer' do
            answer.reload

            expect(answer.body).to eq old_answer_body
          end

          it 'returns :unprocessable_entity' do
            expect(response).to have_http_status :unprocessable_entity
          end

          it 'returns errros' do
            expect(json['errors']).to_not be_nil
          end
        end
      end

      context 'as other user' do
        let(:other_user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: other_user.id) }

        it 'does not change the answer' do
          patch api_path,
                params: { access_token: access_token.token, answer: { body: 'new body' } },
                headers: headers

          answer.reload

          expect(answer.body).to eq old_answer_body
        end
      end
    end
  end

  describe 'DELETE /answers/:id' do
    let!(:resource) { create(:answer) }
    let!(:api_path) { "/api/v1/answers/#{resource.id}" }
    let!(:resource_class) { Answer }
    let!(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:user) { resource.author }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'API DELETEable' do
        let(:public_fields) { %w[id body rating best? created_at updated_at] }
      end
    end
  end
end
