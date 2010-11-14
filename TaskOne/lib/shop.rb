
class Shop
  @interface
  def initialize(interface, items)
    @interface = interface
    @items = items
  end
  
  def item(avatar,item_class)
    items = @items.clone.delete_if{|x| x.item_class != item_class}
    c = @interface.item(items)
    until (items.size+1>= c && c >= 0)
      c = @interface.read_ch-48
    end
    if(c != items.size+1)
      @interface.item_view(avatar, items[c-1])
    end
  end
  
  def buy_item(avatar, item)
    avatar.gold -= item.price
    avatar.backpack.push(item)
    avatar.save
  end
end