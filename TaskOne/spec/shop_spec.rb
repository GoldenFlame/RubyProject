require File.dirname(__FILE__) + '/spec_helper.rb'

describe "shop" do
  before(:each) do
    @world = World.new
    @shop = @world.shop_inst
    @interface =@world.interface
    YamlManage.create_user("test","test")
    @avatar = Avatar.new("data/user/test.yml")
    @item = Item.new("data/item/sword1.yml")
  end
 
  describe "inspect" do
    it "should allow to buy item when avatar has enough gold" do
      @shop.stub!(:buy_item).and_return(true)
      @shop.inspect(@avatar, @item, 1).should be_true
    end

    it "should go back to previous menu when when avatar has enough gold" do
      @shop.stub!(:go_back).and_return(true)
      @shop.inspect(@avatar, @item, 2).should be_true
    end
      
    it "should only allow to go back to previous menu when avatar does not have enough gold to buy item" do
      @avatar.gold = 0
      @shop.stub!(:go_back).and_return(true)
      @shop.inspect(@avatar, @item, 2).should be_true
    end
  end
    
  describe "shop" do
    it "should only show swords in menu" do
      @shop.should_receive(:item).with(@avatar,"sword").and_return(true)
      @world.shop(@avatar, 1).should == true
    end
      
    it "should only show bows in menu" do
      @shop.should_receive(:item).with(@avatar,"bow").and_return(true)
      @world.shop(@avatar, 2).should == true
    end
      
    it "should only show staffs in menu" do
      @shop.should_receive(:item).with(@avatar,"staff").and_return(true)
      @world.shop(@avatar, 3).should == true
    end
  end
    
  describe "buy item" do
    it "should add three items to avatars backpack and decrease gold amount by items price" do
      @avatar.stub!(:save).and_return(true)
      @shop.buy_item(@avatar, @item).should == true
      @shop.buy_item(@avatar, @item).should == true
      @shop.buy_item(@avatar, @item).should == true
      @avatar.gold.should == 70
      @avatar.backpack[:sword].should have(3).items
      @avatar.backpack[:sword].should include('Wooden sword')
    end      
  end
    
  describe "go back" do
    it "should show swords available for purchase" do
      @interface.stub!(:swords).and_return(true)
      @shop.go_back(@avatar, :sword).should == true
    end
    it "should show bows available for purchase" do
      @interface.stub!(:bows).and_return(true)
      @shop.go_back(@avatar, :bow).should == true
    end
    it "should show staffs available for purchase" do
      @interface.stub!(:staffs).and_return(true)
      @shop.go_back(@avatar, :staff).should == true
    end
    
  end
    
  describe "item selection" do
    it "should find Wooden sword in item list" do
      @interface.should_receive(:item).and_return(1)
      expected_item = Item.new("data/item/sword1.yml")
      @interface.should_receive(:inspect).with(@avatar, instance_of(Item)).and_return{|a,b| b.name}
      @shop.item(@avatar, "sword").should == "Wooden sword"
    end
  end
  
  after(:each) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
end