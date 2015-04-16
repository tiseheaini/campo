class TopicsController < ApplicationController
  before_action :login_required, :no_locked_required, except: [:index, :show, :search]
  before_action :find_topic, only: [:edit, :update, :trash]

  def index
    @topics = Topic.includes(:user, :category).page(params[:page])

    if params[:category_id]
      @category = Category.where('lower(slug) = ?', params[:category_id].downcase).first!
      @topics = @topics.where(category: @category)
    end

    # Set default tab
    unless %w(default hot newest).include? params[:tab]
      params[:tab] = 'default'
    end

    case params[:tab]
    when 'hot'
      @topics = @topics.order(hot: :desc)
    when 'newest'
      @topics = @topics.order(id: :desc)
    when 'default'
      @topics = @topics.order(updated_at: :desc)
    end

    # puts @topics_views_hash # topics 访问量
    # => { "topics:5:views" : "5", "topics:2:views" : null, "topics:8:views" : "1" }
    redis_topic_keys = @topics.map {|topic| "topics:#{topic.id}:views" }
    if redis_topic_keys.present?
      @topics_views_hash = (Hash[redis_topic_keys.zip $redis.mget(redis_topic_keys)]).to_json
    else
      @topics_views_hash = Hash.new
    end
  end

  def search
    @topics = Topic.search(
      query: {
        multi_match: {
          query: params[:q].to_s,
          fields: ['title', 'body']
        }
      },
      filter: {
        term: {
          trashed: false
        }
      }
    ).page(params[:page]).records
  end

  def show
    @topic = Topic.find params[:id]

    # topic 访问 + 1
    $redis.incr("topics:#{@topic.id}:views")

    # topic 访问量
    topic_views = $redis.get("topics:#{@topic.id}:views")
    @topic_views = topic_views ? topic_views : 0

    if params[:comment_id] and comment = @topic.comments.find_by(id: params.delete(:comment_id))
      params[:page] = comment.page
    end

    @comments = @topic.comments.includes(:user).order(id: :asc).page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  def new
    @category = Category.where('lower(slug) = ?', params[:category_id].downcase).first if params[:category_id].present?
    @topic = Topic.new category: @category
  end

  def create
    @topic = current_user.topics.create topic_params
  end

  def edit
  end

  def update
    @topic.update_attributes topic_params
  end

  def trash
    @topic.trash
    redirect_via_turbolinks_to topics_path
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :category_id, :body)
  end

  def find_topic
    @topic = current_user.topics.find params[:id]
  end
end
