require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Answer }

    context 'voting' do
      let(:question) { create(:question) }
      describe 'for question' do
        it { should be_able_to :vote, create(:question, author: other) }
        it { should_not be_able_to :vote, create(:question, author: user)}
      end

      describe 'for answer' do
        it { should be_able_to :vote, create(:answer, author: other) }
        it { should_not be_able_to :vote, create(:answer, author: user)}
      end

      describe 'unvoting' do
        it { should be_able_to :destroy, create(:vote, votable: question, user: user) }
        it { should_not be_able_to :unvote, create(:vote, votable: question, user: other) }
      end
    end

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: other) }

    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: other) }

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: other) }

    it { should be_able_to :destroy, create(:answer, author: user) }
    it { should_not be_able_to :destroy, create(:answer, author: other) }
  end
end
