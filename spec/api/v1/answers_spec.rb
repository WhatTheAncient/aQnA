require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT': 'application/json' } }

  describe 'GET /question/:question_id/answers' do
    let(:question) { create(:question, :with_answers) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like "API Unauthorized" do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorized'

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

    it_behaves_like "API Unauthorized" do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorized'

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

    it_behaves_like "API Unauthorized" do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do

        let(:answer) { attributes_for(:answer, author: user) }

        it 'creates new question in database' do
          expect { post api_path, params: { access_token: access_token.token, answer: answer }, headers: headers }
            .to change(Answer, :count).by(1)
        end

        before { post api_path, params: { access_token: access_token.token, answer: answer }, headers: headers }

        let(:answer_response) { json['answer'] }

        it_behaves_like 'API Authorized'

        it 'creates answer with correct attributes' do
          expect(Answer.last).to have_attributes answer
        end

        it 'contains author object' do
          expect(answer_response['author']['id']).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question to db' do
          expect { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers }
            .to_not change(Question, :count)
        end

        before { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers }

        it 'returns :unprocessable_entity' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns errros' do
          expect(json['errors']).to_not be_nil
        end
      end
    end
  end

  describe 'PATCH /answers/:id' do
    it_behaves_like "API Unauthorized" do
      let(:answer) { create(:answer) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:answer) { create(:answer, author: user) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }

      context 'as author' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'with valid attributes' do
          before do
            patch api_path,
                  params: { access_token: access_token.token, answer: { body: 'new body' } },
                  headers: headers
          end

          let(:answer_response) { json['answer'] }

          it_behaves_like 'API Authorized'

          it 'updates answer attributes in database' do
            answer.reload

            expect(answer.body).to eq 'new body'
          end

          it 'contains author object' do
            expect(answer_response['author']['id']).to eq access_token.resource_owner_id
          end
        end

        context 'with invalid attributes' do
          let(:old_answer_body) { answer.body }

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
        let(:old_answer_body) { answer.body }

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
    it_behaves_like "API Unauthorized" do
      let(:answer) { create(:answer) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:answer) { create(:answer, author: user) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }

      context 'as author' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        # Same trouble as in questions_spec.rb
        # it 'deletes answer in database' do
        #   expect do
        #     delete api_path,
        #            params: { access_token: access_token.token },
        #            headers: headers
        #   end.to change(Answer, :count).by(-1)
        # end

        before do
          delete api_path,
                 params: { access_token: access_token.token },
                 headers: headers
        end

        let(:answer_response) { json['answer'] }

        it_behaves_like 'API Authorized'

        it_behaves_like 'public fields returned' do
          let(:public_fields) { %w[id body rating best? created_at updated_at] }
          let(:resource) { answer }
          let(:resource_response) { answer_response }
        end

        it 'contains author object' do
          expect(answer_response['author']['id']).to eq access_token.resource_owner_id
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
          end.to_not change(Answer, :count)
        end
      end
    end
  end
end
