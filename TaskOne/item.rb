class Item < Entity
  attr_reader :file, :name, :item_class, :level, :damage_min, :damage_max, :price
  def parse(data)
    @file = data[:file]
    @name = data[:name]
    @item_class = data[:class]
    @level = data[:level]
    @damage_min = data[:damage_min]
    @damage_max = data[:damage_max]
    @price = data[:price]
  end
  
  def self.find_file_name(item_name)
    item_return = nil
    items = Dir.glob("data/item/*").collect{|x| Item.new(x)}
    items.each do |x|
      if(x.name == item_name)
        item_return = x
        break
      end
    end
    return item_return.file
  end
  
end