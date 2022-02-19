require 'rails_helper'

shared_examples 'linked' do
  resource_sym = "#{described_class.controller_name.singularize}_with_links".to_sym

  let!(:resource) { create(resource_sym) }
  let!(:link) { resource.links.first }

  describe 'DELETE #destroy_link' do
    context 'as author' do
      let!(:author) { resource.author }
      before { login(author) }

      it 'deletes link' do
        expect { delete :destroy_link, params: { id: resource, link_id: link.id }, format: :js }.to change(resource.links, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy_link, params: { id: resource, link_id: link.id }, format: :js
        expect(response).to render_template 'links/destroy'
      end
    end

    context 'as not author' do
      let!(:user) { create(:user) }
      before { login(user) }

      it 'do not deletes link' do
        expect { delete :destroy_link, params: { id: resource, link_id: link.id }, format: :js }.to_not change(resource.links, :count)
      end

      it 'renders destroy template' do
        delete :destroy_link, params: { id: resource, link_id: link.id }, format: :js
        expect(response).to render_template 'links/destroy'
      end
    end
  end
end
