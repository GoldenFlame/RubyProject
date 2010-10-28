require File.dirname(__FILE__) + '/spec_helper.rb'

describe "shop" do
  before(:each) do
    @world = World.new
    @shop = @world.shop_inst
    @interface =@world.interface
  end
 
  describe "inspect" do
    it "should go to buy item when char gold > item price with arg 1" do
      char = {:gold => 100}
      item = {:class => 'sword', :price => 50}
      @shop.stub!(:buy_item).and_return(true)
      @shop.inspect(char, item, 1).should be_true
    end

    it "should go to go back when char gold > item price with arg 2" do
      char = {:gold => 100}
      item = {:class => 'sword', :price => 50}
      @shop.stub!(:go_back).and_return(true)
      @shop.inspect(char, item, 2).should be_true
    end
      
    it "should go to go back when char gold < item price with arg 2" do
      char = {:gold => 100}
      item = {:class => 'sword', :price => 150}
      @shop.stub!(:go_back).and_return(true)
      @shop.inspect(char, item, 2).should be_true
    end
  end
    
  describe "shop" do
    it "should go to item with arg 'sword'" do
      char = nil
      @shop.should_receive(:item).with(char,"sword").and_return(true)
      @world.shop(char, 1).should == true
    end
      
    it "should go to item with arg 'bow'" do
      char = nil
      @shop.should_receive(:item).with(char,"bow").and_return(true)
      @world.shop(char, 2).should == true
    end
      
    it "should go to item with arg 'staff'" do
      char = nil
      @shop.should_receive(:item).with(char,"staff").and_return(true)
      @world.shop(char, 3).should == true
    end
  end
    
  describe "buy item" do
    it "should add item to characters backpack and decrease gold amount by items price and save when item class hash is Array" do
      char = {:gold => 100, :backpack => {:supply => ['Knife', 'Plate']}}
      item = {:name => 'Fork', :class => 'supply', :price => 50}
      YamlManage.stub!(:save_char).and_return(true)
      @shop.buy_item(char, item).should == true
      char[:gold].should == 50
      char[:backpack][:supply].should have(3).items
      char[:backpack][:supply].should include('Fork')
        
    end
    
    it "should add item to characters backpack and decrease gold amount by items price and save when backpack empty" do
      char = {:gold => 100, :backpack => {:supply => 0}}
      item = {:name => 'Fork', :class => 'supply', :price => 50}
      YamlManage.stub!(:save_char).and_return(true)
      @shop.buy_item(char, item).should == true
      char[:gold].should == 50
      char[:backpack][:supply].should have(1).items
      char[:backpack][:supply].should include('Fork')
        
    end
      
    it "should add item to characters backpack and decrease gold amount by items price and save when item class hash is not Array" do
      char = {:gold => 100, :backpack => {:supply => 'Knife'}}
      item = {:name => 'Fork', :class => 'supply', :price => 50}
      YamlManage.stub!(:save_char).and_return(true)
      @shop.buy_item(char, item).should == true
      char[:gold].should == 50
      char[:backpack][:supply].should have(2).items
      char[:backpack][:supply].should include('Fork')
        
    end
      
  end
    
  describe "go back" do
    it "should go to interface swords when menu is sword" do
      char = nil
      @interface.stub!(:swords).and_return(true)
      @shop.go_back(char, :sword).should == true
    end
    it "should go to interface bows when menu is bow" do
      char = nil
      @interface.stub!(:bows).and_return(true)
      @shop.go_back(char, :bow).should == true
    end
    it "should go to interface staffs when menu is staff" do
      char = nil
      @interface.stub!(:staffs).and_return(true)
      @shop.go_back(char, :staff).should == true
    end
    
  end
    
  describe "item selection" do
    it "should find all existing items by criteria and go to inspect with first item: Fork" do
      items = [{:name => 'Fork'}, {:name => 'Silver Fork'}]
      char = nil
      a = mock("Dir", {:collect => items})
      Dir.stub!(:glob).and_return(a)
      YamlManage.stub!(:load_file)
      @interface.should_receive(:item).with(items).and_return(1)
      @interface.should_receive(:inspect).with(char, items[0]).and_return(true)
      @shop.item(char, 'Fork').should == true
    end
  end
end