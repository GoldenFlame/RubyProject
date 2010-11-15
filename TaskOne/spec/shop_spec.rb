require File.dirname(__FILE__) + '/spec_helper.rb'

describe "shop" do
  before(:each) do
    @world = World.new
    @shop = @world.shop_inst
    @interface =@world.interface
    YamlManage.create_user("test","test")
    @avatar = Avatar.new("data/user/test.yml")
  end
    
  describe "buy item" do
    it "should add three items to avatars backpack and decrease gold amount by items price" do
      @avatar.stub!(:save).and_return(true)
      @avatar.gold = 1000
      item = Item.new("data/item/sword1.yml")
      @shop.buy_item(@avatar, item).should == true
      @shop.buy_item(@avatar, item).should == true
      item2 = @world.items.detect{|i| i.name == 'Broad sword'}
      @shop.buy_item(@avatar, item2).should == true
      @avatar.gold.should == 480
      @avatar.backpack.should have(3).items
      @avatar.backpack.should include(item)
    end      
  end
  
  describe "sell item" do
    it "should sell Wooden sword and refund half the price" do
      item = Item.new("data/item/sword1.yml")
      @avatar.backpack.push(item)
      @avatar.gold = 100
      @shop.sell_item(@avatar,item)
      @avatar.gold.should == 105
      @avatar.backpack.should_not include(item)
    end
  end
    
  describe "item selection" do
    it "should find Wooden sword in item list" do
      @interface.should_receive(:item).and_return(1)
      @interface.should_receive(:item_view).with(@avatar, instance_of(Item)).and_return{|a,b| b.name}
      @shop.item(@avatar, "sword").should == "Wooden sword"
    end
    
    it "should return nothing" do
      @interface.should_receive(:item).and_return(4)
      @shop.item(@avatar, "sword").should == nil
    end
    
  end
  
  after(:each) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
end