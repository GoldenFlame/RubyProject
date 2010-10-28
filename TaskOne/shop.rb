require File.join(File.dirname(__FILE__), 'yaml_manage.rb')
require File.join(File.dirname(__FILE__), 'ui.rb')

class Shop
  @interface
  def initialize(interface)
    @interface = interface
  end
  
  def item(char,item)
    item_list = Dir.glob("data/item/#{item}*").collect{|x| YamlManage.load_file(x)}
    c = @interface.item(item_list)
    until (item_list.length>= c && c >= 0)
      c = @interface.read_ch-48
    end
    @interface.inspect(char, item_list[c-1])
  end
  
  def inspect(char,item,c)
    if(char[:gold]>=item[:price])
      case c
      when 1 then buy_item(char,item)
      when 2 then go_back(char,item[:class])
      else inspect(char, item, @interface.read_ch-48)
      end
    else
      case c
      when 2 then go_back(char,item[:class])
      else inspect(char, item, @interface.read_ch-48)
      end
    end
  end
  
  def go_back(char,menu)
    if(menu == :sword)
      @interface.swords(char)
    elsif(menu == :bow)
      @interface.bows(char)
    elsif(menu == :staff)
      @interface.staffs(char)
    end
  end
  
  def buy_item(char, item)
    char[:gold] -= item[:price]
    if(char[:backpack][item[:class].to_sym].class == String)
      tmp = char[:backpack][item[:class].to_sym][0]
      char[:backpack][item[:class].to_sym] = Array.new
      char[:backpack][item[:class].to_sym][0] = tmp
    elsif(char[:backpack][item[:class].to_sym].class != Array)
      char[:backpack][item[:class].to_sym] = Array.new
      char[:backpack][item[:class].to_sym][0] = tmp
    end
    char[:backpack][item[:class].to_sym].push(item[:name])
    YamlManage.save_char(char)
  end
  
  
  
end