shared_examples 'AJAX PATCHable' do
  describe 'As author of resource' do
    before { login(resource.author) }

    context 'with valid attributes' do
      it 'assigns the requested resource to @resource_name' do
        patch :update, params: valid_params, format: :js

        expect(assigns(resource.class.name.downcase.to_sym)).to eq resource
      end

      it 'changes resource attributes' do
        patch :update, params: valid_params, format: :js
        resource.reload

        expect(resource).to have_attributes(new_attributes)
      end

      it 'renders update view' do
        patch :update, params: valid_params, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: invalid_params, format: :js }

      it 'does not change the resource' do
        resource.reload

        expect(resource).to have_attributes(old_attributes)
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'As not author of question' do
    it 'does not change the question' do
      patch :update, params: invalid_params, format: :js
      resource.reload

      expect(resource).to have_attributes(old_attributes)
    end
  end
end