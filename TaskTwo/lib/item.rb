class Item < ActiveRecord::Base  
  has_many :avatar_items
  has_many :shop_items
  scope :by_type, lambda {|item_class| where(:item_class => item_class)}
end