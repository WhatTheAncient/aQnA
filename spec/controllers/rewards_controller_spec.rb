require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user, rewards: create_list(:reward, 5)) }
    before do
      login(user)
      get :index
    end

    it 'assigns all user rewards to @rewards' do
      expect(assigns(:rewards)).to match_array(user.rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
