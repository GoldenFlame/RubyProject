class Item < Entity
  attr_reader :file, :name, :item_class, :level, :damage_min, :damage_max, :armor, :price

  def self.find_file_name(item_name)
    item_return = nil
    item = Dir.glob("data/item/*").collect{|x| Item.new(x)}.detect{|i| i.name == item_name}
    return item.file
  end
  
end