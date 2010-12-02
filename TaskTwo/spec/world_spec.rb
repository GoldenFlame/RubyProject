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
    describe "start a fight" do
      it "should start a fight" do
        @avatar.stub!(:save)
        @interface.stub!(:battle_info)
        @interface.stub!(:fight_menu)
        @interface.stub!(:clear_console)
        @monster.stub!(:attack)
        @world.should_receive(:check_fight_end).and_return(true)
        @world.start_fight(@avatar, @monster).should == nil
      end
    end
    
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
      load.password.should == "test"
    end
  end

  describe "Class selection" do
    it "should specify characters class as warrior and save data" do
      @world.class_warrior(@avatar)
      expected = {:avatar_class => 1, 
        :base_dmg_min => 20, 
        :base_dmg_max => 30, 
        :max_hp => 100, 
        :hp => 100, 
        :max_mana => 10, 
        :mana => 10}
     
      @avatar.attributes.should have_hash_values(expected)
    end
    
    it "should specify characters class as archer and save data" do
      @world.class_archer(@avatar)
      expected = {:avatar_class => 2, 
        :base_dmg_min => 10, 
        :base_dmg_max => 50, 
        :max_hp => 75, 
        :hp => 75, 
        :max_mana => 30, 
        :mana => 30}
      @avatar.attributes.should have_hash_values(expected)
    end
    
    it "should specify characters class as mage and save data" do
      @world.class_mage(@avatar)
      expected = {:avatar_class => 3, 
        :base_dmg_min => 10, 
        :base_dmg_max => 20, 
        :max_hp => 50, 
        :hp => 50, 
        :max_mana => 100, 
        :mana => 100}
      @avatar.attributes.should have_hash_values(expected)
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
      @world.rest(@avatar)
      @avatar.hp.should == @avatar.max_hp
    end
    
    it "should restore characters hp and mana to max" do
      @avatar.mana = 0
      @world.rest(@avatar)
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
