class AvatarItemsController < ApplicationController
  protect_from_forgery
  
  def index
    if(params[:id])
      @items = Item.find_by_id(params[:id])
    else
      @items = Avatar_item.all
    end
    "asdsd"
  end
  
  def show
    if(params[:id])
      @items = Item.find_by_id(params[:id])
    else
      @items = Item.all
    end
    #redirect_to(items_path)
  end
  
end