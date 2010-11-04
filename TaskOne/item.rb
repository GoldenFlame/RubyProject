class Item < Entity
  attr_reader :name, :item_class, :level, :damage_min, :damage_max, :price
  def parse(data)
    @name = data[:name]
    @item_class = data[:class]
    @level = data[:level]
    @damage_min = data[:damage_min]
    @damage_max = data[:damage_max]
    @price = data[:price]
  end
end