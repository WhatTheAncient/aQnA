shared_examples 'API list returnable' do
  it 'should returns full list of comments' do
    resource_associations.each do |association|
      expect(resource_response[association].size).to eq resource.send(association).size
    end
  end
end
