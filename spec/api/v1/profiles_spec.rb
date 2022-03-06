require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE': 'application/json',
                    'ACCEPT': 'application/json' } }

  let(:public_fields) { %w[id email admin created_at updated_at] }
  let(:private_fields) { %w[password encrypted_password] }
  describe 'GET /profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like "API Unauthorized" do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorized'

      it_behaves_like 'public fields returned' do
        let(:resource) { me }
        let(:resource_response) { json['user'] }
      end

      it_behaves_like 'private fields not returned'
    end
  end

  describe 'GET /profiles/other' do
    let(:api_path) { '/api/v1/profiles/other' }

    it_behaves_like "API Unauthorized" do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 5) }
      let(:me) { users[2] }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorized'

      it 'return all items except request author' do
        response_ids = []
        json['users'].each {|user| response_ids << user['id']}

        expect(json['users'].size).to eq users.size - 1
        expect(response_ids).to_not include(me.id)
      end

      it_behaves_like 'public fields returned' do
        let(:resource) { users.first }
        let(:resource_response) { json['users'].first }
      end

      it_behaves_like 'private fields not returned'
    end
  end
end
