require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
    it { should_not be_able_to :me, :profile }
    it { should_not be_able_to :other, :profile }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:another_voter) { create(:user) }
    let(:question) { create(:question,
                            files: [ Rack::Test::UploadedFile.new("#{Rails.root}/app/models/question.rb"),
                                     Rack::Test::UploadedFile.new("#{Rails.root}/app/models/answer.rb")],
                            links: create_list(:link_for_question, 3),
                            author: user) }
    let(:other_question) { create(:question,
                                  files: [ Rack::Test::UploadedFile.new("#{Rails.root}/app/models/question.rb"),
                                           Rack::Test::UploadedFile.new("#{Rails.root}/app/models/answer.rb")],
                                  links: create_list(:link_for_question, 3),
                                  author: other) }

    let(:answer) { create(:answer,
                          files: [ Rack::Test::UploadedFile.new("#{Rails.root}/app/models/question.rb"),
                                   Rack::Test::UploadedFile.new("#{Rails.root}/app/models/answer.rb")],
                          links: create_list(:link_for_question, 3),
                          author: user) }

    let(:other_answer) { create(:answer,
                                files: [ Rack::Test::UploadedFile.new("#{Rails.root}/app/models/question.rb"),
                                         Rack::Test::UploadedFile.new("#{Rails.root}/app/models/answer.rb")],
                                links: create_list(:link_for_question, 3),
                                author: other) }

    let(:vote_for_question) { create(:vote, votable: other_question, user: user) }
    let(:other_vote_for_question) { create(:vote, votable: other_question, user: another_voter) }
    let(:vote_for_answer) { create(:vote, votable: other_answer, user: user) }
    let(:other_vote_for_answer) { create(:vote, votable: other_answer, user: another_voter) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Answer }

    context 'voting' do
      describe 'for question' do
        it { should be_able_to :vote, other_question }
        it { should_not be_able_to :vote, question}
      end

      describe 'for answer' do
        it { should be_able_to :vote, other_answer }
        it { should_not be_able_to :vote, answer }
      end
    end

    context 'unvoting' do
      describe 'for question' do
        it { should be_able_to :unvote, other_question, resource: vote_for_question }
        it { should_not be_able_to :unvote, other_vote_for_question }
      end

      describe 'for answer' do
        it { should be_able_to :unvote, other_answer, resource: vote_for_answer }
        it { should_not be_able_to :unvote, other_vote_for_answer }
      end
    end

    it { should be_able_to :choose_best_answer, question }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, other_question.files.first }

    it { should be_able_to :destroy, question.links.first }
    it { should_not be_able_to :destroy, other_question.links.first }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, answer.files.first }
    it { should_not be_able_to :destroy, other_answer.files.first }

    it { should be_able_to :destroy, answer.links.first }
    it { should_not be_able_to :destroy, other_answer.links.first }

    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it { should be_able_to  :me, :profile}

    it { should be_able_to :other, :profile }
  end
end
