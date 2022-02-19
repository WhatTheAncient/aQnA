module Filed
  extend ActiveSupport::Concern

  def destroy_file
    @file = ActiveStorage::Attachment.find(params[:file_id])
    @file.purge if current_user.author_of?(@file.record)

    render 'files/destroy'
  end
end
