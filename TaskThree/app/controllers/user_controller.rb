class UserController < ApplicationController
  
def authenticate
    @user = Avatar.new(params[:userform])
    valid_user = Avatar.find(:first,:conditions => ["name = ? and password = ?",@user.name, @user.password])
    if valid_user
      session[:user_id]=valid_user.id
      session[:user] = valid_user
      redirect_to :action => 'private'
    else
      flash[:notice] = "Invalid User/Password"
      redirect_to :action=> 'login'
    end
end

  def login
  end

  def private
    if !session[:user_id]
      redirect_to :action=> 'login'
    end
  end

  def logout
    if session[:user_id]
      reset_session
      redirect_to :action=> 'login'
    end
  end

end