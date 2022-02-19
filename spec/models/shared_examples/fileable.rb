require 'rails_helper'

shared_examples 'fileable' do
  it 'have many attached files' do
    expect(described_class.new.files).to be_instance_of(ActiveStorage::Attached::Many)
  end
end