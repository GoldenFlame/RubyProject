# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


cities       = City.create([{
                                :name => 'Ellion',
                                #:shop_id => shops[0].id
                            },
                            {
                                :name => 'Asmo',
                                #:shop_id => shops[1].id
                            },
                            {
                                :name => 'Tewi',
                                #:shop_id => shops[2].id
                            }])

shops        = Shop.create([{
                                :name    => 'Junk & much more',
                                :city_id => cities[0].id
                            },
                            {
                                :name => 'Come or get lost',
                                :city_id => cities[1].id
                            },
                            {
                                :name => 'Best shit in da world',
                                :city_id => cities[2].id
                            }])


avatars      = Avatar.create([
                                 {
                                     :name         => 'Fallen',
                                     :password     => 'simple',
                                     :avatar_class => 0,
                                     :level        => 1,
                                     :exp          => 0,
                                     :city_id      => cities[0].id,
                                     :gold         => 1000,
                                     :base_dmg_min => 10,
                                     :base_dmg_max => 20,
                                     :max_hp       => 100,
                                     :hp           => 100,
                                     :max_mana     => 50,
                                     :mana         => 50,
                                     :weapon       => nil,
                                     :armor        => nil
                                 },
                                 {
                                     :name         => 'Sin',
                                     :password     => 'simple',
                                     :avatar_class => 1,
                                     :level        => 10,
                                     :exp          => 0,
                                     :city_id      => cities[0].id,
                                     :gold         => 1000,
                                     :base_dmg_min => 10,
                                     :base_dmg_max => 20,
                                     :max_hp       => 100,
                                     :hp           => 100,
                                     :max_mana     => 50,
                                     :mana         => 50,
                                     :weapon       => nil,
                                     :armor        => nil
                                 }])

items        = Item.create([{
                                :name       => 'Training sword',
                                :item_class => 'sword',
                                :level      => 1,
                                :price      => 10,
                                :damage_min => 10,
                                :damage_max => 15,
                                :armor      => 0
                            },
                            {
                                :name       => 'Simple sword',
                                :item_class => 'sword',
                                :level      => 5,
                                :price      => 100,
                                :damage_min => 20,
                                :damage_max => 25,
                                :armor      => 0
                            },
                            {
                                :name       => 'Claymore',
                                :item_class => 'sword',
                                :level      => 10,
                                :price      => 500,
                                :damage_min => 50,
                                :damage_max => 75,
                                :armor      => 0
                            },
                            {
                                :name       => 'Training bow',
                                :item_class => 'bow',
                                :level      => 1,
                                :price      => 10,
                                :damage_min => 10,
                                :damage_max => 20,
                                :armor      => 0
                            },
                            {
                                :name       => 'Simple bow',
                                :item_class => 'bow',
                                :level      => 5,
                                :price      => 100,
                                :damage_min => 20,
                                :damage_max => 40,
                                :armor      => 0
                            },
                            {
                                :name       => 'Hunters bow',
                                :item_class => 'bow',
                                :level      => 10,
                                :price      => 500,
                                :damage_min => 50,
                                :damage_max => 95,
                                :armor      => 0
                            },
                            {
                                :name       => 'Training staff',
                                :item_class => 'staff',
                                :level      => 1,
                                :price      => 10,
                                :damage_min => 20,
                                :damage_max => 25,
                                :armor      => 0
                            },
                            {
                                :name       => 'Simple staff',
                                :item_class => 'staff',
                                :level      => 5,
                                :price      => 100,
                                :damage_min => 45,
                                :damage_max => 45,
                                :armor      => 0
                            },
                            {
                                :name       => 'Enchanted staff',
                                :item_class => 'staff',
                                :level      => 10,
                                :price      => 500,
                                :damage_min => 60,
                                :damage_max => 60,
                                :armor      => 0
                            },
                            {
                                :name       => 'Training armor',
                                :item_class => 'armor',
                                :level      => 1,
                                :price      => 20,
                                :damage_min => 0,
                                :damage_max => 0,
                                :armor      => 10
                            },
                            {
                                :name       => 'Simple armor',
                                :item_class => 'armor',
                                :level      => 5,
                                :price      => 140,
                                :damage_min => 0,
                                :damage_max => 0,
                                :armor      => 30
                            },
                            {
                                :name       => 'Enforced armor',
                                :item_class => 'armor',
                                :level      => 10,
                                :price      => 740,
                                :damage_min => 0,
                                :damage_max => 0,
                                :armor      => 70
                            }])

avatar_items = AvatarItem.create([{
                                      :avatar_id => avatars[0].id,
                                      :item_id   => items[0].id,
                                      :amount    => 2

                                  },
                                  {
                                      :avatar_id => avatars[0].id,
                                      :item_id   => items[1].id,
                                      :amount    => 1
                                  },
                                  {
                                      :avatar_id => avatars[1].id,
                                      :item_id   => items[4].id,
                                      :amount    => 1
                                  },
                                  {
                                      :avatar_id => avatars[1].id,
                                      :item_id   => items[5].id,
                                      :amount    => 5
                                  }])


fight_areas  = FightArea.create([{
                                     :name    => 'Cursed Mountain',
                                     :city_id => cities[0].id
                                 },
                                 {
                                     :name    => 'Dwoo lake',
                                     :city_id => cities[0].id
                                 },
                                 {
                                     :name    => 'Alomo forest',
                                     :city_id => cities[1].id
                                 },
                                 {
                                     :name    => 'Yotoo plains',
                                     :city_id => cities[2].id
                                 }])


monsters     = Monster.create([{
                                   :name          => "Sin",
                                   :fight_area_id => fight_areas[0].id,
                                   :max_hp        => 75,
                                   :base_dmg_min  => 0,
                                   :base_dmg_max  => 20,
                                   :exp_bonus     => 100,
                                   :gold_max      => 400
                               },
                               {
                                   :name          => "Pet rock",
                                   :fight_area_id => fight_areas[0].id,
                                   :max_hp        => 500,
                                   :base_dmg_min  => 5,
                                   :base_dmg_max  => 10,
                                   :exp_bonus     => 300,
                                   :gold_max      => 100
                               },
                               {
                                   :name          => "Daevoo",
                                   :fight_area_id => fight_areas[1].id,
                                   :max_hp        => 50,
                                   :base_dmg_min  => 0,
                                   :base_dmg_max  => 20,
                                   :exp_bonus     => 100,
                                   :gold_max      => 400
                               },
                               {
                                   :name          => "Golem",
                                   :fight_area_id => fight_areas[2].id,
                                   :max_hp        => 200,
                                   :base_dmg_min  => 30,
                                   :base_dmg_max  => 50,
                                   :exp_bonus     => 300,
                                   :gold_max      => 500
                               },
                               {
                                   :name          => "Angry bunny",
                                   :fight_area_id => fight_areas[3].id,
                                   :max_hp        => 400,
                                   :base_dmg_min  => 60,
                                   :base_dmg_max  => 100,
                                   :exp_bonus     => 3000,
                                   :gold_max      => 5000
                               }])

shop_items   = ShopItem.create([{
                                    :shop_id => shops[0].id,
                                    :item_id => items[0].id
                                },
                                {
                                    :shop_id => shops[0].id,
                                    :item_id => items[3].id
                                },
                                {
                                    :shop_id => shops[0].id,
                                    :item_id => items[6].id
                                },
                                {
                                    :shop_id => shops[0].id,
                                    :item_id => items[9].id
                                },
                                {
                                    :shop_id => shops[1].id,
                                    :item_id => items[1].id
                                },
                                {
                                    :shop_id => shops[1].id,
                                    :item_id => items[4].id
                                },
                                {
                                    :shop_id => shops[1].id,
                                    :item_id => items[7].id
                                },
                                {
                                    :shop_id => shops[1].id,
                                    :item_id => items[10].id
                                },
                                {
                                    :shop_id => shops[2].id,
                                    :item_id => items[2].id
                                },
                                {
                                    :shop_id => shops[2].id,
                                    :item_id => items[5].id
                                },
                                {
                                    :shop_id => shops[2].id,
                                    :item_id => items[8].id
                                },
                                {
                                    :shop_id => shops[2].id,
                                    :item_id => items[11].id
                                }
                               ])