require 'rails_helper'

shared_examples 'votable' do
  resource_sym = "vote_for_#{described_class.model_name.singular}".to_sym

  it { should have_many :votes }

  describe '.rating' do
    let!(:votable) { create(described_class.model_name.singular.to_sym) }
    let!(:good_votes) { create_list(resource_sym, 5, state: 'good', votable: votable) }
    let!(:bad_votes) { create_list(resource_sym, 2, state: 'bad', votable: votable) }

    it 'returns the sum of resource rating, which counts on "state" column' do
      votes = votable.votes.sum(:state)
      expect(votable.rating).to eq votes
    end
  end
end
