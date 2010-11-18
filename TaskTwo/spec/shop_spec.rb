require File.dirname(__FILE__) + '/spec_helper.rb'

describe "shop" do
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    
    @avatar.backpack_init
    @world = World.new
    @shop = @world.shop_inst
    @interface =@world.interface
  end
    
  describe "buy item" do
    it "should add two swords and armor to avatars backpack and decrease gold amount by 30" do
      @avatar.gold = 1000
      @shop.buy_item(@avatar, @item_weapon)
      @shop.buy_item(@avatar, @item_weapon)
      @shop.buy_item(@avatar, @item_armor)
      @avatar.gold.should == 970
      weapon = AvatarItem.find_by_avatar_id_and_item_id(@avatar.id, @item_weapon.id)
      armor = AvatarItem.find_by_avatar_id_and_item_id(@avatar.id, @item_armor.id)
      weapon.amount.should == 2
      armor.amount.should == 1
      @avatar.backpack.should have(4).items
      @avatar.backpack.should include(@item_armor)
    end      
  end
  
  describe "sell item" do
    it "should sell test sword and refund half the price" do      
      @shop.buy_item(@avatar, @item_weapon)
      before = AvatarItem.find_or_create_by_avatar_id_and_item_id(@avatar.id, @item_weapon.id)
      @avatar.gold = 1000
      @shop.sell_item(@avatar,@item_weapon)
      @avatar.gold.should == 1005
      after = AvatarItem.find_or_create_by_avatar_id_and_item_id(@avatar.id, @item_weapon.id)
      after.amount.should == before.amount - 1
    end
  end
    
  describe "item selection" do
    it "should find test sword in item list" do
      @interface.should_receive(:item).and_return(0)
      @interface.should_receive(:item_view).with(@avatar, instance_of(Item)).and_return{|a,b| b.name}
      @shop.item(@avatar, "sword").should == "test sword"
    end
    
    it "should return nothing" do
      @interface.should_receive(:item).and_return(4)
      @shop.item(@avatar, "sword").should == nil
    end
    
  end
end