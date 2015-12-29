class AuthController < ApplicationController
  def signin
    if request.post?
      login = params[:login].downcase
      @user = if login.include?('@')
                User.where('lower(email) = ?', login).first
              else
                User.where('lower(username) = ?', login).first
              end

      if @user && @user.authenticate(params[:password])
        store_session(@user)
        return_url = add_param(session.delete(:return_to), "session_key", session.id)
        redirect_to return_url
      else
        flash[:warning] = "账号或密码错误"
        redirect_to :back
      end
    end
  end

  def signup
    @user = User.new

    if request.post?
      @user = User.new params.require(:user).permit(:username, :email, :password).merge(locale: locale)
      if @user.save
        store_session(@user)
        UserMailer.confirmation(@user.id).deliver
        return_url = add_param(session.delete(:return_to), "session_key", session.id)
        redirect_to return_url
      else
        render :signup
      end
    end
  end
end
