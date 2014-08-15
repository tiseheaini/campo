class AttachmentsController < ApplicationController
  before_action :login_required

  def create
    params[:file] = params.delete :upload_file
    @attachment = current_user.attachments.create params.permit(:file)

    render json: { success: true, msg: '上传成功', file_path: @attachment.file.url }
  end
end
