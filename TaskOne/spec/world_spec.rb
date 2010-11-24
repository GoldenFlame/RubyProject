require File.dirname(__FILE__) + '/spec_helper.rb'

describe World do
  
  before(:each) do
    @world = World.new
    @interface = @world.interface
    YamlManage.create_user("test","test")
    @avatar = Avatar.new("data/user/test.yml")
    @monster = Monster.new("data/monster/Sin.yml")
  end
  
  describe "Register" do
    it "should register new avatar" do
      YamlManage.should_receive(:create_user).and_return(true)
      @world.reg("new","user")
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
      expected = {:avatar_class => 3, 
        :base_dmg_min => 10, 
        :base_dmg_max => 20, 
        :max_hp => 50, 
        :hp => 50, 
        :max_mana => 100, 
        :mana => 100}
      @avatar.should be_loaded_with(expected)
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
    
      
    describe "find item" do
      it "should find item by given name and return its data" do
        item = Item.new("data/item/sword1.yml")
        result = @world.find_item('Wooden sword')
        expected = {:name => 'Wooden sword', :item_class => 'sword'}
        result.should be_loaded_with(expected)
      end
    end
  end
  
  
  describe "rest" do
    it "should restore characters hp max" do
      @avatar.hp = 0
      @world.rest(@avatar)
      @avatar.hp.should == @avatar.max_hp
    end
    
    it "should restore characters mana to max" do
      @avatar.mana = 0
      @world.rest(@avatar)
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
  
  describe "fight system" do
    before(:each) do
      YamlManage.create_user("test","test")
      @avatar = Avatar.new("data/user/test.yml")
      @monster = Monster.new("data/monster/Sin.yml")
    end
    describe "fight" do
      it "should initiate a fight with a monster sin" do
        @avatar.stub!(:save)
        @interface.stub!(:battle_info)
        @interface.stub!(:fight_menu)
        @interface.stub!(:clear_console)
        @monster.stub!(:attack)
        @world.should_receive(:check_fight_end).and_return(true)
        @world.start_fight(@avatar, 'sin').should == nil
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
      it "should give avatar a bonus 3 gold" do
        a = mock("Random", {:rand => 3})
        Random.stub!(:new).and_return(a)
        @interface.stub!(:winner_msg)
        @world.player_prize( @avatar, @monster)
        @avatar.gold.should == 103
      end
      
      it "should give avatar a bonus 30 exp" do
        a = mock("Random", {:rand => 3})
        Random.stub!(:new).and_return(a)
        @interface.stub!(:winner_msg)
        @world.player_prize( @avatar, @monster)
        @avatar.exp.should == 30
      end
    end
    
    describe "penalty" do
      it "should decrease avatars exp by " do
        a = mock("Random", {:rand => 30})
        Random.stub!(:new).and_return(a)
        @interface.stub!(:looser_msg)
        @world.player_penalty(@avatar, @monster)
        @avatar.gold.should == 97
      end
    end
    
    
  end
  after(:all) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
  
  
  
    
end
