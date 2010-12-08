class ShopsController < ApplicationController
  protect_from_forgery
    before_filter :user
  
  def user
    @user = Avatar.find(session[:user_id])
  end
  
  def index
    @params = "no"
    if params[:buy]
      redirect_to :action => 'buy'
    elsif params[:sell]
      redirect_to :action => 'sell'
    elsif params[:back]
      redirect_to :controller => 'user', :action => 'private'
    end
  end
  
  def buy
    @item_list = @user.city.shop.items
  end
  
  def view
    @item = Item.find(params[:item])
  end
  
  def buy_item
    @user.buy_item(Item.find(params[:item]))
    redirect_to :action => "buy"
  end
  
  def sell
    @item_list = @user.avatar_items
  end
  
  def sell_item
    @user.sell_item(Item.find(params[:item]))
    redirect_to :action => "sell"
  end
  
  
end
