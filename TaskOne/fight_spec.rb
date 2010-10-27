require 'simplecov'
SimpleCov.start

require File.dirname(__FILE__) + '/fight.rb'

  describe "Fight system" do
    @char
    before(:each) do
      @char = {:hp => 100, :exp => 10, :gold => 300,:base_dmg_min => 2, :base_dmg_max => 10}
    end
    describe "fight" do
      it "should start a fight with a monster and after each round save" do
        YamlManage.stub!(:load_file)
        @interface.stub!(:battle_info)
        @interface.stub!(:fight_menu)
        @interface.stub!(:clear_console)
        Fight.stub!(:attack)
        Fight.stub!(:check_fight_end).and_return(true)
        YamlManage.stub!(:save_char)
        Fight.fight(@char, "Sin").should == nil
      end
    end
    
    describe "check if someone was defeated and give bonus or penalty to player" do
      it "should return defeated? true because one entity has 0 hp" do
        Fight.stub!(:player_penalty)
        Fight.check_fight_end({:hp => 0}, {:hp => 20}).should == true
      end
      
      it "should return defeated? true because another entity has 0 hp" do
        Fight.stub!(:player_prize)
        Fight.check_fight_end({:hp => 10}, {:hp => 0}).should == true
      end
      
      it "should return defeated? false because both entitys has more hp than 0" do
        Fight.check_fight_end({:hp => 10}, {:hp => 20}).should == false
      end
    end
    
    describe "bonus" do
      it "should give character a bonus of 30 exp points and 3 gold" do
        a = mock("Random", {:rand => 3})
        Random.stub!(:new).and_return(a)
        Fight.player_prize( @char, {:exp_bonus => 30, :gold_max => 100})
        @char[:exp].should == 40
        @char[:gold].should == 303
      end
    end
    
    describe "penalty" do
      it "should decrease characters exp by " do
        a = mock("Random", {:rand => 30})
        Random.stub!(:new).and_return(a)
        Fight.player_penalty(@char, {:exp_bonus => 30, :gold_max => 100})
        @char[:exp].should == 7
        @char[:gold].should == 297
      end
    end
    
    describe "attack" do
      it "should decrease defenders healt points by attackers dealt damage" do
        #damage is calculated by taking random number in range of characters min damage and max damage
        #therefor mock object a returning value 1 instead of random
        a = mock("Random", {:rand => 1})
        Random.stub!(:new).and_return(a)
        Fight.attack(@char, @char)
        @char[:hp].should == 99
      end
    end
    
    describe "skill attack" do
      it "should decrease defenders health points by attackers doubled maximum damage" do
        Fight.skill(@char, @char)
        @char[:hp].should == 80
      end
    end
    
    describe "use item" do
      it "should increase attackers health points by 10" do
        hp_before = @char[:hp]
        Fight.use_item(@char)
        @char[:hp].should == hp_before + 10
      end
    end
  end