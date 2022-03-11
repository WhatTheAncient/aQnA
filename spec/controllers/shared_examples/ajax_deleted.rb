shared_examples 'AJAX DELETEable' do
  context 'as author' do
    before { login(author) }

    it 'deletes resource' do
      expect { delete :destroy, params: { id: resource }, format: :js }.to change(resource_collection, :count).by(-1)
    end

    it 'renders destroy template' do
      delete :destroy, params: { id: resource }, format: :js
      expect(response).to render_template :destroy
    end
  end

  context 'as not author' do
    let!(:user) { create(:user) }
    before { login(user) }

    it 'do not deletes resource' do
      expect { delete :destroy, params: { id: resource }, format: :js }.to_not change(resource_collection, :count)
    end

    it 'responses with forbidden status' do
      delete :destroy, params: { id: resource }, format: :js
      expect(response).to have_http_status(:forbidden)
    end
  end
end
