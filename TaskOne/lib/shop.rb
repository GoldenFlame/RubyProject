
class Shop
  @interface
  def initialize(interface, items)
    @interface = interface
    @items = items
  end
  
  def item(avatar,item_class)
    items = @items.select{|x| x.item_class == item_class}
    c = @interface.item(items)
    if(c != items.size+1)
      @interface.item_view(avatar, items[c-1])
    end
  end
  
  def buy_item(avatar, item)
    avatar.gold -= item.price
    avatar.backpack.push(item)
    avatar.save
  end
  
  def sell_item(avatar,item)
    avatar.gold += item.price/2
    avatar.backpack.delete(item)
    avatar.save
  end
end