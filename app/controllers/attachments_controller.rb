class AttachmentsController < ApplicationController
  before_action :login_required

  def create
    @attachment = current_user.attachments.create params.require(:attachment).permit(:file)

    render json: { success: true, file_path: @attachment.file.url }
  end
end
