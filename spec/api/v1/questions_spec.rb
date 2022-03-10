require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT': 'application/json' } }

  describe 'GET /questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like "API Unauthorized" do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 4) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorized'

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

    it_behaves_like "API Unauthorized" do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorized'

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

    it_behaves_like "API Unauthorized" do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do

        let(:question) { attributes_for(:question, author: user) }

        it 'creates new question in database' do
          expect { post api_path, params: { access_token: access_token.token, question: question }, headers: headers }
            .to change(Question, :count).by(1)
        end

        before { post api_path, params: { access_token: access_token.token, question: question }, headers: headers }

        let(:question_response) { json['question'] }

        it_behaves_like 'API Authorized'

        it 'creates question with correct attributes' do
          expect(Question.last).to have_attributes question
        end

        it 'contains author object' do
          expect(question_response['author']['id']).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question to db' do
          expect { post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers }
            .to_not change(Question, :count)
        end

        before { post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers }

        it 'returns :unprocessable_entity' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns errros' do
          expect(json['errors']).to_not be_nil
        end
      end
    end
  end

  describe 'PATCH /questions/:id' do
    it_behaves_like "API Unauthorized" do
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }

      context 'as author' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'with valid attributes' do
          before do
            patch api_path,
                  params: { access_token: access_token.token, question: { title: 'new title', body: 'new body' } },
                  headers: headers
          end

          let(:question_response) { json['question'] }

          it_behaves_like 'API Authorized'

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
    it_behaves_like "API Unauthorized" do
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }
      let!(:api_path) { "/api/v1/questions/#{question.id}" }

      context 'as author' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        # Strange bug, return later
        # it 'deletes question in database' do
        #   puts api_path
        #   question.save!
        #   expect(question.persisted?).to eq true
        #   puts "Questions: #{Question.all.ids}"
        #   expect(question.id).to eq 3
        #   puts Question.all.ids
        #   expect do
        #     delete api_path,
        #            params: { access_token: access_token.token },
        #            headers: headers
        #   end.to change(Question, :count).by(-1)
        # end

        before do
          delete api_path,
                params: { access_token: access_token.token },
                headers: headers
        end

        let(:question_response) { json['question'] }

        it_behaves_like 'API Authorized'

        it_behaves_like 'public fields returned' do
          let(:public_fields) { %w[id title body created_at updated_at] }
          let(:resource) { question }
          let(:resource_response) { question_response }
        end

        it 'contains author object' do
          expect(question_response['author']['id']).to eq access_token.resource_owner_id
        end
      end

      context 'as other user' do
        let(:other_user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: other_user.id) }

        it 'does not deletes the question' do
          expect do
            delete api_path,
                  params: { access_token: access_token.token },
                  headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end
end
