class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :user
  
  def user
    if(session[:user_id])
      @user = Avatar.find(session[:user_id])
      if(@user.weapon != nil)
        @weapon = Item.find(@user.weapon)
      end
      if(@user.armor != nil)
        @armor = Item.find(@user.armor)
      end
    end
  end
end
