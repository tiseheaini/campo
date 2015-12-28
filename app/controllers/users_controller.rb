class UsersController < ApplicationController
  before_action :no_login_required, only: [:new, :create]

  def new
    store_location params[:return_to]
    @user = User.new
  end

  def create
    @user = User.new params.require(:user).permit(:username, :email, :password).merge(locale: locale)
    if @user.save
      login_as @user
      UserMailer.confirmation(@user.id).deliver
      redirect_back_or_default root_url
    else
      render :new
    end
  end

  def check_email
    respond_to do |format|
      format.json do
        render json: !User.where('lower(email) = ?', params[:user][:email].downcase).where.not(id: params[:id]).exists?
      end
    end
  end

  def check_username
    respond_to do |format|
      format.json do
        render json: !User.where('lower(username) = ?',  params[:user][:username].downcase).where.not(id: params[:id]).exists?
      end
    end
  end

  def callback
    uri = URI('https://api.weibo.com/oauth2/access_token')
    res = Net::HTTP.post_form(uri, 'client_id' => WEIBO['app_key'], 'client_secret' => WEIBO['client_secret'], 'grant_type' => 'authorization_code', 'code' => params['code'], 'redirect_uri' => WEIBO['redirect_uri'])
    u_json = JSON.parse res.body
    uri = URI('https://api.weibo.com/2/users/show.json')
    params = { :access_token => u_json['access_token'], uid: u_json['uid'] }
    uri.query = URI.encode_www_form(params)
    resp = JSON.parse Net::HTTP.get_response(uri).body

    auth_user = find_user_by_uid('weibo', resp['id'].to_s)

    if auth_user
      login_as auth_user
    else
      auth_user = create_user_with_weibo(resp, u_json['access_token'])
      login_as auth_user
    end
    $redis.set("weibo:#{auth_user.id}:avatar", resp['avatar_large'])

    if session[:return_to]
      store_session(auth_user)
      return_url = add_param(session.delete(:return_to), "session_key", session.id)
      redirect_to return_url
    else
      redirect_to root_path
    end
  end

  private

  def store_session(user)
    key = "user:#{session.id}"
    data = user.data.to_s
    $redis.set(key, data, ex: 7.days)
  end

  def add_param(url, param_name, param_value)
    uri = URI(url)
    params = URI.decode_www_form(uri.query || '') << [param_name, param_value]
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  def find_user_by_uid(provider, uid)
    authorization = Authorization.find_by provider: provider, uid: uid
    if authorization
      login_as authorization.user
      return authorization.user
    else
      return nil
    end
  end

  def create_user_with_weibo(resp, a_token)
    user = User.create(name: resp['screen_name'], username: resp['screen_name'], password: [*('A'..'Z')].sample(8).join)
    user.update(confirmed: true, send_comment_email: false, send_mention_email: false)
    Authorization.create(user_id: user.id ,uid: resp['id'], access_token: a_token, provider: 'weibo')
    user
  end
end
