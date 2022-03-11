shared_examples 'AJAX POSTable' do
  describe 'with valid attributes' do
    it 'should increase resource count in db' do
      expect { post :create, params: valid_params, format: :js }
        .to change(resource_collection, :count).by(1)
    end

    it 'should render :create template' do
      post :create, params: valid_params, format: :js

      expect(response).to render_template :create
    end
  end

  describe 'with invalid attributes' do
    it 'should not increase resource count in db' do
      expect { post :create, params: invalid_params, format: :js }
        .to_not change(resource_collection, :count)
    end

    it 'should render :create template' do
      post :create, params: invalid_params, format: :js

      expect(response).to render_template :create
    end
  end
end
