require File.dirname(__FILE__) + '/spec_helper.rb'

describe World do
  before(:all) do 
    @world = World.new
    @interface = @world.interface
    @shop = @world.shop_inst
  end
  
  before(:each) do
    @world = World.new
    @interface = @world.interface
    YamlManage.create_user("test","test")
    @avatar = Avatar.new("data/user/test.yml")
  end

  describe "Class selection" do
    it "should specify characters class as warrior and save data" do
      @avatar.stub!(:save).and_return(true)
      @world.class_warrior(@avatar).should == true
      @avatar.avatar_class.should == 1
      @avatar.base_dmg_min.should == 20
      @avatar.base_dmg_max.should == 30
      @avatar.max_hp.should == 100
      @avatar.hp.should == 100
      @avatar.max_mana.should == 10
      @avatar.mana.should == 10
    end
    
    it "should specify characters class as archer and save data" do
      @avatar.stub!(:save).and_return(true)
      @world.class_archer(@avatar).should == true
      @avatar.avatar_class.should == 2
      @avatar.base_dmg_min.should == 10
      @avatar.base_dmg_max.should == 50
      @avatar.max_hp.should == 75
      @avatar.hp.should == 75
      @avatar.max_mana.should == 30
      @avatar.mana.should == 30
    end
    
    it "should specify characters class as mage and save data" do
      @avatar.stub!(:save).and_return(true)
      @world.class_mage(@avatar).should == true
      @avatar.avatar_class.should == 3
      @avatar.base_dmg_min.should == 10
      @avatar.base_dmg_max.should == 20
      @avatar.max_hp.should == 50
      @avatar.hp.should == 50
      @avatar.max_mana.should == 100
      @avatar.mana.should == 100
    end
  end
  
  describe "menu" do
    
    describe "find item" do
      it "should find item by given name and return its data" do
        item = Item.new("data/item/sword1.yml")
        result = @world.find_item('Wooden sword')
        result.class.should == item.class
        result.name.should == item.name
        result.item_class.should == item.item_class
      end
    end
   
    end
  
  
  describe "rest" do
    it "should restore characters hp and mana to max" do
      @avatar.hp = 0
      @avatar.mana = 0
      @world.rest(@avatar)
      @avatar.hp.should == @avatar.max_hp
      @avatar.mana.should == @avatar.max_mana
    end
  end
  
  describe "arena monster seach" do
    it "should find monster from area 1 Blob in city Ellion" do
      a = mock("Random", {:rand => 1})
        Random.stub!(:new).and_return(a)
      @world.find_arena_monster(@world.citys[0]).should == "Blob"
    end
  end
  
  
    
end
