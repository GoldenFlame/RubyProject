require 'simplecov'
SimpleCov.start

require File.dirname(__FILE__) + '/world.rb'
describe World do
  @world
  @char
  @interface
  before(:all) do 
    @world = World.new
    @interface = @world.get_interface
  end
  before(:each) do
    @char = @world.logs("test")
  end
  describe "Registration" do
    it "should create account 'test' with password 'test'" do
      
      @world.stub!(:main_menu)#.and_return(true)
      YamlManage.stub!(:create_char).and_return(true)
      @world.reg("test2", "test").should == true
    end
  end
  
  describe "Login" do
    it "should load user account 'test' if it exists" do
      YamlManage.stub!(:load_file).and_return(true)
      @world.logs("test").should == true
    end
  end
  
  describe "Class selection" do
    it "should detect users choice as class warrior and call function" do
      @world.stub!(:class_warrior).and_return(true)
      @world.choose_class(@char, 1).should == true
    end
    
    it "should detect users choice as class archer and call function" do
      @world.stub!(:class_archer).and_return(true)
      @world.choose_class(@char, 2).should == true
    end
    
    it "should detect users choice as class mage and call function" do
      @world.stub!(:class_mage).and_return(true)
      @world.choose_class(@char, 3).should == true
    end
    
    it "should specify characters class as warrior and save data" do
      YamlManage.stub!(:save_char).and_return(true)
      @world.class_warrior(@char).should == true
      @char[:class].should == 1
      @char[:base_dmg_min].should == 20
      @char[:base_dmg_max].should == 30
      @char[:max_hp].should == 100
      @char[:hp].should == 100
      @char[:max_mana].should == 10
      @char[:mana].should == 10
    end
    
    it "should specify characters class as archer and save data" do
      YamlManage.stub!(:save_char).and_return(true)
      @world.class_archer(@char).should == true
      @char[:class].should == 2
      @char[:base_dmg_min].should == 10
      @char[:base_dmg_max].should == 50
      @char[:max_hp].should == 75
      @char[:hp].should == 75
      @char[:max_mana].should == 30
      @char[:mana].should == 30
    end
    
    it "should specify characters class as mage and save data" do
      YamlManage.stub!(:save_char).and_return(true)
      @world.class_mage(@char).should == true
      @char[:class].should == 3
      @char[:base_dmg_min].should == 10
      @char[:base_dmg_max].should == 20
      @char[:max_hp].should == 50
      @char[:hp].should == 50
      @char[:max_mana].should == 100
      @char[:mana].should == 100
    end
  end
  
  describe "menu" do
    describe "main menu" do
      it "should go to choose character class when class is not chosen" do
        char = {:class => 0}
        @interface.stub!(:login).and_return(char)
        @world.exit
        @interface.stub!(:choose_class).and_return(true)
        @world.main_menu.should == true
      end
    
      it "should go to world method when characters class is chosen" do
        char = {:class => 1}
        @interface.stub!(:login).and_return(char)
        @world.exit
        @world.stub!(:check_lvlup).and_return(true)
        @interface.stub!(:go_to_world).and_return(true)
        @world.main_menu.should == [true,true]
      end
    end
    
    
    describe "exit" do
      it "should return true" do
        @world.exit.should == true
      end
    end
    
    describe "go to world" do
      it "should go to arena when 1" do
        char = nil
        @interface.stub!(:arena).and_return(true)
        @world.go_to_world(char, 1).should == true
      end
      
      it "should go to wilds when 2" do
        char = {:current_city => 0}
        @interface.stub!(:wilds).and_return(true)
        @world.go_to_world(char, 2).should == true
      end
      
      it "should go to shop when 3" do
        char = {:current_city => 0}
        @interface.stub!(:shop).and_return(true)
        @world.go_to_world(char, 3).should == true
      end
      
      it "should go to inn when 4" do
        char = {:current_city => 0}
        @interface.stub!(:inn).and_return(true)
        @world.go_to_world(char, 4).should == true
      end
      
      it "should go to exit when 5" do
        char = nil
        @world.stub!(:exit).and_return(true)
        @world.go_to_world(char, 5).should == true
      end
    end
    
    describe "inn" do
      it "should go to rest when 1" do
        char = nil
        @world.stub!(:rest).and_return(true)
        @world.inn(char, 1).should == true
      end
    end
    
    describe "shop" do
      it "should go to item with arg 'sword'" do
        char = nil
        @world.should_receive(:item).with(char,"sword").and_return(true)
        @world.shop(char, 1).should == true
      end
      
      it "should go to item with arg 'bow'" do
        char = nil
        @world.should_receive(:item).with(char,"bow").and_return(true)
        @world.shop(char, 2).should == true
      end
      
      it "should go to item with arg 'staff'" do
        char = nil
        @world.should_receive(:item).with(char,"staff").and_return(true)
        @world.shop(char, 3).should == true
      end
    end
    
    describe "inspect" do
      it "should go to buy item when char gold > item price with arg 1" do
        char = {:gold => 100}
        item = {:class => 'sword', :price => 50}
        @world.stub!(:buy_item).and_return(true)
        @world.inspect(char, item, 1).should == true
      end
      
      it "should go to go back when char gold > item price with arg 2" do
        char = {:gold => 100}
        item = {:class => 'sword', :price => 50}
        @world.stub!(:go_back).and_return(true)
        @world.inspect(char, item, 2).should == true
      end
      
      it "should go to go back when char gold < item price with arg 2" do
        char = {:gold => 100}
        item = {:class => 'sword', :price => 150}
        @world.stub!(:go_back).and_return(true)
        @world.inspect(char, item, 2).should == true
      end
    end
    
    describe "buy item" do
      it "should add item to characters backpack and decrease gold amount by items price and save" do
        char = {:gold => 100, :backpack => ['Knife', 'Plate']}
        item = {:name => 'Fork', :price => 50}
        YamlManage.stub!(:save_char).and_return(true)
        @world.buy_item(char, item).should == true
        char[:gold].should == 50
        char[:backpack].include?("Fork").should == true
        
      end
    end
    
    describe "go back" do
      it "should go to interface swords when menu is sword" do
        char = nil
        @interface.stub!(:swords).and_return(true)
        @world.go_back(char, :sword).should == true
      end
      it "should go to interface bows when menu is bow" do
        char = nil
        @interface.stub!(:bows).and_return(true)
        @world.go_back(char, :bow).should == true
      end
      it "should go to interface staffs when menu is staff" do
        char = nil
        @interface.stub!(:staffs).and_return(true)
        @world.go_back(char, :staff).should == true
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
        @world.item(char, 'Fork').should == true
      end
    end
    
    describe "wilds" do
      it "should go to area: Toxic Lake" do
        char = nil
        city = {:fight_1 => 'Contaminated forest', :fight_2 => 'Toxic Lake', :fight_3 => 'Enchanting planes'}
        @interface.should_receive(:go_to_area).with(char,city[:fight_2]).and_return(true)
        @world.wilds(char,2, city).should == true
      end
    end
    
    describe "arenas" do
      it "should go to fight with arg 1" do
        char = {:current_city => 0}
        @world.stub!(:fight).and_return(true)
        @world.arena(char, 1).should == true
      end
    end
    
    describe "fight menu" do
      it "should attack" do
        char = nil
        enemy = nil
        @world.stub!(:attack).and_return(true)
        @world.fight_menu(char, enemy, 1).should == true
      end
      
      it "should use skill" do
        char = nil
        enemy = nil
        @world.stub!(:skill).and_return(true)
        @world.fight_menu(char, enemy, 2).should == true
      end  
      
      it "should use item" do
        char = nil
        enemy = nil
        @world.stub!(:use_item).and_return(true)
        @world.fight_menu(char, enemy, 3).should == true
      end 

    end
    
  end
  
  
  describe "Fight system" do
    describe "fight" do
      it "should start a fight with a monster and after each round save" do
        YamlManage.stub!(:load_file)
        @interface.stub!(:battle_info)
        @interface.stub!(:fight_menu)
        @world.stub!(:attack)
        @world.stub!(:check_fight_end).and_return(true)
        YamlManage.stub!(:save_char)
        @world.fight(@char, "Sin").should == nil
      end
    end
    
    describe "check if someone was defeated and give bonus or penalty to player" do
      it "should return defeated? true because one entity has 0 hp" do
        #check_fight_end(player, enemy)
        @world.stub!(:player_penalty)
        @world.check_fight_end({:hp => 0}, {:hp => 20}).should == true
      end
      
      it "should return defeated? true because another entity has 0 hp" do
        @world.stub!(:player_prize)
        @world.check_fight_end({:hp => 10}, {:hp => 0}).should == true
      end
      
      it "should return defeated? false because both entitys has more hp than 0" do
        @world.check_fight_end({:hp => 10}, {:hp => 20}).should == false
      end
    end
    
    describe "bonus" do
      it "should give character a bonus of 30 exp points and 1 gold" do
        a = mock("Random", {:rand => 3})
        Random.stub!(:new).and_return(a)
        char = {:exp => 10, :gold => 20}
        @world.player_prize( char, {:exp_bonus => 30, :gold_max => 100})
        char[:exp].should == 40
        char[:gold].should == 23
      end
    end
    
    describe "penalty" do
      it "should decrease characters exp by " do
        a = mock("Random", {:rand => 3})
        char = {:exp => 10, :gold => 20}
        Random.stub!(:new).and_return(a)
        @world.player_penalty(char, {:exp_bonus => 9, :gold_max => 100})
        char[:exp].should == 7
        char[:gold].should == 19
      end
    end
    
    describe "attack" do
      it "should decrease defenders healt points by attackers dealt damage" do
        #damage is calculated by taking random number in range of characters min damage and max damage
        #therefor mock object a returning value 1 instead of random
        a = mock("Random", {:rand => 1})
        Random.stub!(:new).and_return(a)
        hp_before = @char[:hp]
        @world.attack(@char, @char)
        @char[:hp].should == hp_before - 1
      end
    end
    
    describe "skill attack" do
      it "should decrease defenders health points by attackers doubled maximum damage" do
        hp_before = @char[:hp]
        @world.skill(@char, @char)
        @char[:hp].should == hp_before - @char[:base_dmg_max] * 2
      end
    end
    
    describe "use item" do
      it "should increase attackers health points by 10" do
        hp_before = @char[:hp]
        @world.use_item(@char)
        @char[:hp].should == hp_before + 10
      end
    end
  end
  
  describe "rest" do
    it "should restore characters hp and mana" do
      test_char = {:hp => 10, :max_hp => 100, :mana => 10, :max_mana => 100}
      @world.rest(test_char)
      test_char[:hp].should == test_char[:max_hp]
      test_char[:mana].should == test_char[:max_mana]
    end
  end
  
  describe "arena monster seach" do
    it "should find monster from area 1 Blob" do
      city = {:fight_area => 2, :f1monsters => ["Sin", "Blob"], :f2monsters => ["Dark", "Sunny", "Nami"]}
      a = mock("Random", {:rand => 1})
        Random.stub!(:new).and_return(a)
      @world.find_arena_monster(city).should == "Blob"
    end
    
      
    it "should find monster from area 2 Nami " do
      city = {:fight_area => 2, :f1monsters => ["Sin", "Blob"], :f2monsters => ["Dark", "Sunny", "Nami"]} 
      a = mock("Random", {:rand => 2})
        Random.stub!(:new).and_return(a)
      @world.find_arena_monster(city).should == "Nami"
    end
  end
  
  
    
end
