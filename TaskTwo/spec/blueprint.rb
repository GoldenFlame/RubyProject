blueprint :avatar do
  @avatar = Avatar.create(:name => "test",
      :password => "test", 
      :avatar_class => 0,
      :level => 1,
      :exp => 0,
      :city_id => 0,
      :gold => 100,
      :base_dmg_min => 0,
      :base_dmg_max => 0,
      :max_hp => 10,
      :hp => 10,
      :max_mana => 10,
      :mana => 10,
      :weapon => nil,
      :armor => nil
      )
  item = Item.create(:name => "test bow")
      
  @avatar.avatar_items.create(:amount => 1, :item_id => item.id)
end

blueprint :item_weapon do
  @item_weapon = Item.create(:name => "test sword", :item_class => "sword", :price => 10,:damage_min => 10, :damage_max => 20)
end

blueprint :item_weapon2 do
  @item_weapon2 = Item.create(:name => "test bow", :item_class => "bow", :price => 60,:damage_min => 10, :damage_max => 20)
end

blueprint :item_armor do
  @item_armor = Item.create(:name => "test armor", :item_class => "armor", :price => 10,:armor => 5)
end

blueprint :item_armor2 do
  @item_armor2 = Item.create(:name => "test metal armor", :item_class => "armor", :price => 30,:armor => 10)
end
blueprint :city2 do
  item = Item.create(:name => "test bow")
  shopas = Shop.create(:name => "tada")
  shop_itemas = ShopItem.create(:shop => shopas, :item => item)
  @city2 = City.create(:name => "Leav")
  @city2.shop = shopas
  @city2.fight_areas.create(:name => "forest")
  @city2.fight_areas[0].monsters.create(:name => "sin", 
  :hp => 100, 
  :base_dmg_min => 5, 
  :base_dmg_max => 10,
  :exp_bonus => 10,
  :gold_max => 100)
end

blueprint :city do
  item = Item.create(:name => "test bow")
  shopas = Shop.create(:name => "sdas")
  shop_itemas = ShopItem.create(:shop => shopas, :item => item)
  @city = City.create(:name => "Testion")
  @city.shop = shopas
  @city.fight_areas.create(:name => "swamp")
  @city.fight_areas[0].monsters.create(:name => "blob", 
  :hp => 100, 
  :base_dmg_min => 5, 
  :base_dmg_max => 10,
  :exp_bonus => 10,
  :gold_max => 100)
end