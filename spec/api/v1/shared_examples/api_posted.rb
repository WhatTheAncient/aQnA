shared_examples 'API POSTable' do
  context 'with valid attributes' do
    it 'creates new resource in database' do
      expect { post api_path, params: valid_params, headers: headers }.to change(resource_class, :count).by(1)
    end

    before { post api_path, params: valid_params, headers: headers }

    let(:resource_response) { json["#{resource_class.name.downcase}"] }

    it 'creates resource with correct attributes' do
      expect(resource_class.last).to have_attributes resource
    end

    it 'contains author object' do
      expect(resource_response['author']['id']).to eq access_token.resource_owner_id
    end
  end

  context 'with invalid attributes' do
    it 'does not save the resource to db' do
      expect { post api_path, params: invalid_params, headers: headers }.to_not change(Question, :count)
    end

    before { post api_path, params: invalid_params, headers: headers }

    it 'returns :unprocessable_entity' do
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'returns errros' do
      expect(json['errors']).to_not be_nil
    end
  end
end
