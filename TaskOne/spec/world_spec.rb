require File.dirname(__FILE__) + '/spec_helper.rb'

describe World do
  before(:all) do 
    @world = World.new
    @interface = @world.interface
    @shop = @world.shop_inst
  end
  before(:each) do
    @char = {:name => 'SpecTest',
        :password => 'test',
        :class => 2,
        :level => 10,
        :exp => 1000,
        :current_city => 1,
        :gold => 13200,
        :base_dmg_min => 10,
        :base_dmg_max => 50,
        :max_hp => 50,
        :hp => 35};
  end
  describe "Registration" do
    it "should call yaml char file create" do
      @world.stub!(:main_menu)
      YamlManage.stub!(:create_char).and_return(true)
      @world.reg("test2", "test").should == true
    end
  end
  
  describe "Login" do
    it "should call yaml file load if file exists" do
      YamlManage.stub!(:load_file).and_return(true)
      File.stub!(:exist?).and_return(true)
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
    
    describe "inventory menu" do
      it "should go to item menu inventory when arg is 1 and there is sword in backpack" do
        char = {:backpack => {:sword => 'Broken blade'}}
        @interface.stub!(:item_menu_inventory).and_return(true)
        @world.show_inventory(char, 1, 1, 1, 1).should == true
      end
      
      it "should go to item menu inventory when arg is 2 and there is bow in backpack" do
        char = {:backpack => {:bow => 'Elemental bow'}}
        @interface.stub!(:item_menu_inventory).and_return(true)
        @world.show_inventory(char, 2, 1, 1, 1).should == true
      end
      
      it "should go to item menu inventory when arg is 3 and there is staff in backpack" do
        char = {:backpack => {:staff => 'Ancient staff'}}
        @interface.stub!(:item_menu_inventory).and_return(true)
        @world.show_inventory(char, 3, 1, 1, 1).should == true
      end
      
      it "should go to world menu when arg is 4" do
        @interface.stub!(:go_to_world).and_return(true)
        @world.show_inventory(nil, 4, 1, 1, 1).should == true
      end
    end
    
    describe "find item" do
      it "should find item by given name and return its data" do
        example={:name => 'Wooden sword', :class => 'sword', :level => 1, 
          :damage_min => 10, :damage_max => 20, :price => 10}
        @world.find_item('Wooden sword').should be_eql(example)
      end
    end
    
    describe "welcome menu" do
      it "should go to registration when 1" do
        @interface.stub!(:reg).and_return(true)
        @world.login(1)
      end
      
      it "should go to login when 2" do
        @interface.stub!(:logs).and_return(true)
        @world.login(2)
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
      
      it "should go to stats when 5" do
        char = {:current_city => 0}
        @interface.stub!(:show_stats).and_return(true)
        @world.go_to_world(char, 5).should == true
      end
      
      it "should go to inventory when 6" do
        char = {:current_city => 0}
        @interface.stub!(:show_inventory).and_return(true)
        @world.go_to_world(char, 6).should == true
      end
      
      it "should go to exit when 7" do
        char = nil
        @world.stub!(:exit).and_return(true)
        @world.go_to_world(char, 7).should == true
      end
    end
    
    
    describe "inn" do
      it "should go to rest when 1" do
        char = nil
        @world.stub!(:rest).and_return(true)
        @world.inn(char, 1).should == true
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
        fight = @world.fight
        fight.stub!(:fight).and_return(true)
        @world.arena(char, 1).should == true
      end
    end
    
    describe "fight menu" do
      it "should attack" do
        char = nil
        enemy = nil
        fight = @world.fight
        fight.stub!(:attack).and_return(true)
        @world.fight_menu(char, enemy, 1).should == true
      end
      
      it "should use skill" do
        char = nil
        enemy = nil
        fight = @world.fight
        fight.stub!(:skill).and_return(true)
        @world.fight_menu(char, enemy, 2).should == true
      end  
      
      it "should use item" do
        char = nil
        enemy = nil
        fight = @world.fight
        fight.stub!(:use_item).and_return(true)
        @world.fight_menu(char, enemy, 3).should == true
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
