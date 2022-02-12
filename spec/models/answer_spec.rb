require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :author }
  it { should belong_to :question }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_instance_of(ActiveStorage::Attached::Many)
  end
end
