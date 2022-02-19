require 'rails_helper'

shared_examples 'filed' do
  resource_sym = "#{described_class.controller_name.singularize}_with_files".to_sym

  let!(:resource) { create(resource_sym) }
  let!(:file) { resource.files.first }

  describe 'DELETE #destroy_file' do
    context 'as author' do
      let!(:author) { resource.author }
      before { login(author) }

      it 'deletes file' do
        expect { delete :destroy_file, params: { id: resource, file_id: file.id }, format: :js }.to change(resource.files, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy_file, params: { id: resource, file_id: file.id }, format: :js
        expect(response).to render_template 'files/destroy'
      end
    end

    context 'as not author' do
      let!(:user) { create(:user) }
      before { login(user) }

      it 'do not deletes file' do
        expect { delete :destroy_file, params: { id: resource, file_id: file.id }, format: :js }.to_not change(resource.files, :count)
      end

      it 'renders destroy template' do
        delete :destroy_file, params: { id: resource, file_id: file.id }, format: :js
        expect(response).to render_template 'files/destroy'
      end
    end
  end
end
