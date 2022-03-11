shared_examples 'API DELETEable' do
  context 'as author' do
    ### Got bug here, replace this test with 'it deletes answer in database'
    # it 'should delete object from db' do
    #   expect do
    #     delete api_path,
    #            params: { access_token: access_token.token },
    #            headers: headers
    #   end.to change(resource_class, :count).by(-1)
    # end

    before do
      delete api_path,
             params: { access_token: access_token.token },
             headers: headers
    end

    it 'deletes answer in database' do
      expect(resource_class).to_not exist(resource.id)
    end

    let!(:resource_response) { json["#{resource_class.name.downcase}"] }

    it_behaves_like 'public fields returned'

    it 'contains author object' do
      expect(resource_response['author']['id']).to eq access_token.resource_owner_id
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
      end.to_not change(resource_class, :count)
    end
  end
end

