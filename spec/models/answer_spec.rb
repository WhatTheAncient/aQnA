require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_one :question}

  it { should validate_presence_of :body}
end
