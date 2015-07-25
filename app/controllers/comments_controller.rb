class CommentsController < ApplicationController
  before_action :login_required, :no_locked_required
  before_action :find_comment, only: [:edit, :cancel, :update, :trash]
  before_action :interval, only: [:create]

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
    @all_comments = Topic.find(@comment.commentable_id).comments.order('created_at')
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

  def interval
    circle, interval, ttl = CONFIG['comment']['circle'], CONFIG['comment']['interval'], CONFIG['comment']['interval']
    bucket_no = Time.now.to_i % circle / interval
    key = "topic:#{params[:topic_id]}:user:#{current_user.id}:comment:post:bucket:#{bucket_no}"

    unless $redis.exists key
      $redis.incr key
      $redis.expire key, ttl
    else
      count = $redis.get(key).to_i
      if count >= circle/interval
        render js: 'swal({title: "您回帖的频率过高，稍微等一等", timer: 1500})'
      else
        $redis.incr key
      end
    end
  end
end
