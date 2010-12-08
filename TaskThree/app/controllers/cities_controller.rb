class CitiesController < ApplicationController
  protect_from_forgery
  before_filter :user
  before_filter :check_fight
  

  def user
    @user = Avatar.find(session[:user_id])
  end
  
  def check_fight
    if(@user.fight != nil)
      @user.fight.destroy  
    end
  end
  
  def index
    if(params[:id])
      @items = Item.find_by_id(params[:id])
    else
      @items = City.all
    end
    "asdsd"
  end
  
  def show
    
  end
  
  def arena
    
  end
  
  def wilds
    @wilds = Avatar.find(session[:user_id]).city.fight_areas
  end
  
  def shop
    
  end
  
  def inn
    @user.city.rest(@user)
  end
  
end
