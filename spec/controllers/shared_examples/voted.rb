require 'rails_helper'

shared_examples 'voted' do

  let!(:vote) { resource.votes[1] }

  describe 'POST #vote' do
    context 'as author of resource or user who voted for resource' do
      let!(:author) { resource.author }
      before { login(author) }

      it 'do not creates vote' do
        expect { post :vote, params: { id: resource,
                                         votable: resource.class.to_s,
                                         vote_state: 'good' },
                                         format: :json }.to_not change(resource.votes, :count)
      end

      it 'returns forbidden status' do
        post :vote, params: { id: resource, votable: resource.class.to_s, vote_state: 'good' }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'as not author' do
      let!(:user) { create(:user) }
      before { login(user) }

      it 'creates vote' do
        expect { post :vote, params: { id: resource,
                                       votable: resource.class.to_s,
                                       vote_state: 'good' },
                                       format: :json }.to change(resource.votes, :count).by(1)
      end

      it 'returns vote in json with created status' do
        post :vote, params: { id: resource, votable: resource.class.to_s, vote_state: 'good' }, format: :json
        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)

        expect(response_body['vote']['state']).to eq 'good'
        expect(response_body['rating']).to be_present
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'as author of resource' do
      let!(:author) { vote.user }
      before { login(author) }

      it 'deletes vote' do
        expect { delete :unvote, params: { id: resource, vote_id: vote.id }, format: :json }.to change(resource.votes, :count).by(-1)
      end

      it 'it returns votable rating and id with :ok status' do
        delete :unvote, params: { id: resource, vote_id: vote.id }, format: :json
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['rating']).to eq resource.rating
        expect(response_body['votable_id']).to eq vote.votable.id
      end
    end

    context 'as not author' do
      let!(:user) { create(:user) }
      before { login(user) }

      it 'do not deletes vote' do
        expect { delete :unvote, params: { id: resource, vote_id: vote.id }, format: :json }.to_not change(resource.votes, :count)
      end

      it 'return forbidden status' do
        delete :unvote, params: { id: resource, vote_id: vote.id }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
