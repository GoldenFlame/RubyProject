class AvatarController < ApplicationController
  protect_from_forgery
  
  before_filter :user
  
  def user
    @user = Avatar.find(session[:user_id])
  end
  
  def index
  end
  
  def inventory
    @items = @user.avatar_items
  end
  
  def travel
    if(params[:dest])
      @user.travel(City.find(params[:dest]))
      redirect_to :controller => "user", :action => "private"
    end
    @cities = City.all
  end
  
  def item
    @item = Item.find(params[:avatar_item])
  end
  
  def equip
    @user.equip(Item.find(params[:item]))
    redirect_to :action => "inventory"
  end
  
  def disequip
    if(params[:weapon])
      @user.disequip(Item.find(@user.weapon))
    elsif(params[:armor])
      @user.disequip(Item.find(@user.armor))
    end
    redirect_to :action => "stats"
  end
  
  def stats
    if(@user.weapon != nil)
      @weapon = Item.find(@user.weapon)
    end
    if(@user.armor != nil)
      @armor = Item.find(@user.armor)
    end
  end

  
end
