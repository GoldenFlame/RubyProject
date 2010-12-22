class AvatarController < ApplicationController
  
  def inventory
    @items = @user.avatar_items
  end
  
  def travel
    if(params[:dest])
      @user.travel(City.find(params[:dest]))
      @user.save
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
  


  
end
