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
    res = Net::HTTP.post_form(uri, 'client_id' => '2380174108', 'client_secret' => 'b5215f1adec402e3548ae55f9a6f2376', 'grant_type' => 'authorization_code', 'code' => params['code'], 'redirect_uri' => "http://www.shiyueqingxin.com/users/weibo/callback")
    u_json = JSON.parse res.body
    uri = URI('https://api.weibo.com/2/users/show.json')
    params = { :access_token => u_json['access_token'], uid: u_json['uid'] }
    uri.query = URI.encode_www_form(params)
    resp = JSON.parse Net::HTTP.get_response(uri).body

    auth_user = find_user_by_uid('weibo', resp['id'].to_s)

    if auth_user
      login_as auth_user
    else
      login_as create_user_with_weibo(resp, u_json['access_token'])
    end

    redirect_to root_path
  end

  private

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
    username = PinYin.of_string(resp['screen_name']).join

    if User.find_by(username: username).present?
      username << '_' << [*('A'..'Z')].sample(4).join
    end

    user = User.create(name: resp['screen_name'], username: username, password: [*('A'..'Z')].sample(8).join)
    user.update(confirmed: true, send_comment_email: false, send_mention_email: false)
    Authorization.create(user_id: user.id ,uid: resp['id'], access_token: a_token, provider: 'weibo')
    user
  end
end
