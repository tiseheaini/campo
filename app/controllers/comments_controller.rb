class CommentsController < ApplicationController
  before_action :login_required, :no_locked_required
  before_action :find_comment, only: [:edit, :cancel, :update, :trash]

  def create
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
    @all_comments = @commentable.comments.order('created_at')
    @comment = @commentable.comments.new params.require(:comment).permit(:body).merge(user: current_user)
    if @comment.save
      Resque.enqueue(CommentNotificationJob, @comment.id)
    end
  end

  def edit
  end

  def cancel
  end

  def update
    @comment.update_attributes params.require(:comment).permit(:body)
    @all_comments = Topic.find(@comment.commentable_id).comments.order('created_at')
  end

  def trash
    @comment.trash
  end

  private

  def find_comment
    @comment = current_user.comments.find params[:id]
  end
end
