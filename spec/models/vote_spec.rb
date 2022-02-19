require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { create(:vote_for_question) }

  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :state }
  it { should validate_uniqueness_of(:user).scoped_to(:votable_type, :votable_id) }
  it { should define_enum_for(:state).with_values(good: 1, bad: -1) }
end
