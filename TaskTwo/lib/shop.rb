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
    itemdb = Avatar_item.find_or_create_by_user_and_item(avatar.id, item.id)
    if(itemdb.amount == nil)
      itemdb.amount = 0
    end
    itemdb.amount += 1
    itemdb.save
    avatar.save
  end
  
  def sell_item(avatar,item)
    avatar.gold += item.price/2
    avatar.backpack.delete(item)
    itemdb = Avatar_item.find_by_user_and_item(avatar.id, item.id)
    itemdb.amount -= 1
    itemdb.save
    avatar.save
  end
end