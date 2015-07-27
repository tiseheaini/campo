require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test "should create comment" do
    login_as create(:user)
    topic = create(:topic)

    assert_difference "topic.comments.count" do
      xhr :post, :create, topic_id: topic, comment: { body: 'body' }
    end
  end

  test "should create comment interval rate limiting" do
    login_as create(:user)
    topic = create(:topic)
    circle, interval, times = CONFIG['comment']['circle'], CONFIG['comment']['interval'], CONFIG['comment']['times']
    bucket_no = Time.now.to_i % circle / interval
    key = "topic:#{topic.id}:user:#{current_user.id}:comment:post:bucket:#{bucket_no}"

    $redis.set(key, times)

    assert_no_difference "topic.comments.count" do
      xhr :post, :create, topic_id: topic, comment: { body: 'new comment' }
    end
  end

  test "should create notification job after create comment" do
    login_as create(:user)
    topic = create(:topic)

    assert_difference "Resque.size(:notification)" do
      xhr :post, :create, topic_id: topic, comment: { body: 'body' }
    end
  end

  test "should edit comment" do
    comment = create(:comment)
    login_as comment.user

    xhr :get, :edit, id: comment
    assert_response :success, @response.body
  end

  test "should cancel edit" do
    comment = create(:comment)
    login_as comment.user

    xhr :get, :cancel, id: comment
    assert_response :success, @response.body
  end

  test "shuold update comment" do
    comment = create(:comment)
    login_as comment.user

    xhr :patch, :update, id: comment, comment: { body: 'change' }
    assert_equal 'change', comment.reload.body
  end

  test "should trash comment" do
    comment = create(:comment)
    login_as comment.user

    assert_difference "Comment.trashed.count" do
      xhr :delete, :trash, id: comment
    end
  end
end
