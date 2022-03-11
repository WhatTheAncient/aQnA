require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT': 'application/json' } }

  describe 'GET /questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 4) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 4
      end

      it_behaves_like 'public fields returned' do
        let(:public_fields) { %w[id title body created_at updated_at] }
        let(:resource) { question }
        let(:resource_response) { question_response }
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end
    end
  end

  describe 'GET /questions/:id' do
    let(:question) { create(:question, :with_files, :with_links, :with_comments) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'public fields returned' do
        let(:public_fields) { %w[id title body created_at updated_at] }
        let(:resource) { question }
        let(:resource_response) { json['question'] }
      end

      it_behaves_like 'API list returnable' do
        let(:resource_associations) { %w[links files comments] }
        let(:resource) { question }
        let(:resource_response) { json['question'] }
      end

      context 'links' do
        it_behaves_like 'public fields returned' do
          let(:public_fields) { %w[id name url created_at updated_at] }
          let(:resource) { question.links.first }
          let(:resource_response) { json['question']['links'].first }
        end
      end

      context 'files' do
        it 'returns file url' do
          expect(json['question']['files'].first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(
            question.files.first, only_path: true
          )
        end
      end

      context 'comments' do
        it_behaves_like 'public fields returned' do
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource) { question.comments.first }
          let(:resource_response) { json['question']['comments'].first }
        end
      end

      it 'contains author object' do
        expect(json['question']['author']['id']).to eq question.author.id
      end
    end
  end

  describe 'POST /questions' do
    let(:api_path) { "/api/v1/questions" }
    let(:method) { :post }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'API POSTable' do
        let(:resource_class) { Question }
        let(:resource) { attributes_for(:question, author: user) }
        let(:valid_params) { { access_token: access_token.token, question: resource } }
        let(:invalid_params) { { access_token: access_token.token, question: attributes_for(:question, :invalid) } }
      end
    end
  end

  describe 'PATCH /questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'as author' do
        let(:user) { question.author }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'with valid attributes' do
          before do
            patch api_path,
                  params: { access_token: access_token.token, question: { title: 'new title', body: 'new body' } },
                  headers: headers
          end

          let(:question_response) { json['question'] }

          it 'updates question attributes in database' do
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'contains author object' do
            expect(question_response['author']['id']).to eq access_token.resource_owner_id
          end
        end

        context 'with invalid attributes' do
          before do
            patch api_path,
                  params: { access_token: access_token.token, question: attributes_for(:question, :invalid) },
                  headers: headers
          end

          it 'does not change the question' do
            question.reload

            expect(question.title).to eq 'MyString'
            expect(question.body).to eq 'MyText'
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

        it 'does not change the question' do
          patch api_path,
                params: { access_token: access_token.token, question: { title: 'new title', body: 'new body' } },
                headers: headers

          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end
      end
    end
  end

  describe 'DELETE /questions/:id' do
    let!(:resource) { create(:question) }
    let!(:api_path) { "/api/v1/questions/#{resource.id}" }
    let!(:resource_class) { Question }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:user) { resource.author }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'API DELETEable' do
        let(:public_fields) { %w[id title body created_at updated_at] }
      end
    end
  end
end
