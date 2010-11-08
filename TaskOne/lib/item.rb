class Item < Entity
  attr_reader :file, :name, :item_class, :level, :damage_min, :damage_max, :price

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