class Shop < ActiveRecord::Base  
  has_many :shop_items
  has_many :items, :through => :shop_items

  
  
end