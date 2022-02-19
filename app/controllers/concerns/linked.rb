module Linked
  extend ActiveSupport::Concern

  def destroy_link
    @link = Link.find(params[:link_id])
    @link.destroy if current_user.author_of?(@link.linkable)

    render 'links/destroy'
  end
end
