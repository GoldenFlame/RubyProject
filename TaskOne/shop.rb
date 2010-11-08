require File.join(File.dirname(__FILE__), 'yaml_manage.rb')
require File.join(File.dirname(__FILE__), 'ui.rb')

class Shop
  @interface
  def initialize(interface, items)
    @interface = interface
    @items = items
  end
  
  def item(avatar,item_class)
    items = @items.clone.delete_if{|x| x.item_class != item_class}
    c = @interface.item(items)
    until (items.size>= c && c >= 0)
      c = @interface.read_ch-48
    end
    @interface.inspect(avatar, items[c-1])
  end
  
  
  
  def inspect(avatar,item,c)
    if(avatar.gold>=item.price)
      case c
      when 1 then buy_item(avatar,item)
      when 2 then go_back(avatar,item.item_class)
      else inspect(avatar, item, @interface.read_ch-48)
      end
    else
      case c
      when 2 then go_back(avatar,item.item_class)
      else inspect(avatar, item, @interface.read_ch-48)
      end
    end
  end
  
  def go_back(avatar,menu)
    if(menu == :sword)
      @interface.swords(avatar)
    elsif(menu == :bow)
      @interface.bows(avatar)
    elsif(menu == :staff)
      @interface.staffs(avatar)
    end
  end
  
  def buy_item(avatar, item)
    avatar.gold -= item.price
    if(avatar.backpack == nil)
      avatar.backpack = Array.new
    end
    avatar.backpack.push(item)
    avatar.save
  end
  
  
  
end