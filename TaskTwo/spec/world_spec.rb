require File.dirname(__FILE__) + '/spec_helper.rb'

describe World do

  
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
    @avatar.backpack_init
    @monster = @city.fight_areas[0].monsters[0]
    
    @world = World.new
    @interface = @world.interface
    @shop = @world.shop_inst
  end
  
  describe "fight system" do
    describe "check if someone was defeated and give bonus or penalty to player" do
      it "should give player penalty" do
        @avatar.hp = 0
        @world.stub!(:player_penalty)
        @world.check_fight_end(@avatar, @monster).should == true
      end
      
      it "should give player a bonus" do
        @monster.hp = 0
        @world.stub!(:player_prize)
        @world.check_fight_end(@avatar, @monster).should == true
      end
      
      it "should do nothing" do
        @world.check_fight_end(@avatar, @monster).should == false
      end
    end
    
    describe "bonus" do
      it "should give avatar a bonus of 10 exp points and 3 gold" do
        a = mock("Random", {:rand => 3})
        Random.stub!(:new).and_return(a)
        @interface.stub(:winner_msg)
        @world.player_prize( @avatar, @monster)
        @avatar.exp.should == 10
        @avatar.gold.should == 103
      end
    end
    
    describe "penalty" do
      it "should decrease avatars gold by 3 " do
        a = mock("Random", {:rand => 30})
        Random.stub!(:new).and_return(a)
        @interface.stub(:looser_msg)
        @world.player_penalty(@avatar, @monster)
        @avatar.gold.should == 97
      end
    end
    

  end
  
  
  
  describe "Register" do
    it "should register new avatar" do
      a = mock("City", {:id => @city.id})
      City.stub!(:find_by_name).and_return(a)
      @world.reg("test","user")
      Avatar.find_by_name_and_password("test", "user").should_not == nil
    end
  end
  
  describe "Login" do
    it "should load avatar test" do
      load = @world.logs("test")
      load.class.should == @avatar.class
      load.name.should == @avatar.name
      load.password.should == @avatar.password
    end
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
    describe "exit" do
      it "should set program to exit" do
        @world.exit
        @world.exitcmd.should == true
      end
    end
    
    describe "main menu" do
      it "should let choose avatar`s class" do
        @interface.should_receive(:login).and_return(@avatar)
        @interface.should_receive(:choose_class)
        @world.exit
        @world.main_menu
      end
      
      it "should show main game menu" do
        @avatar.avatar_class = 1
        @interface.should_receive(:login).and_return(@avatar)
        @interface.stub(:clear_console)
        @avatar.should_receive(:check_lvlup)
        @interface.should_receive(:go_to_world)
        @avatar.should_receive(:save)
        @world.exit
        @world.main_menu
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
    it "should find monster blob" do
      
      a = mock("Random", {:rand => 0})
        Random.stub!(:new).and_return(a)
      @world.find_arena_monster(@city).name.should == "blob"
    end
  end
  
  
    
end
