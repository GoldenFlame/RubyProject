class AvatarItem < ActiveRecord::Base  
  belongs_to :avatar
  belongs_to :item
end