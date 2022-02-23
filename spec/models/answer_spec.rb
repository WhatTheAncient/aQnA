require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'fileable'
  it_behaves_like 'commentable'

  it { should belong_to :author }
  it { should belong_to :question }

  it { should validate_presence_of :body }
end
