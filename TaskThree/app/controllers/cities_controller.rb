class CitiesController < ApplicationController
  protect_from_forgery
  before_filter :user
  

  def user
    @user = Avatar.find(session[:user_id])
  end
  
  def index

  end
  
  def wilds
    @wilds = Avatar.find(session[:user_id]).city.fight_areas
  end

  def inn
    @user.city.rest(@user)
  end
  
end
