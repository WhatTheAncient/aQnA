shared_examples 'public fields returned' do
  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples 'private fields not returned' do
  it 'does not return private fields' do
    private_fields.each do |attr|
      expect(json).to_not have_key(attr)
    end
  end
end