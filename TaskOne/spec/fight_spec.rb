require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
  describe "@fight system" do
    before(:each) do
      @char = {:hp => 100, :exp => 10, :gold => 300,:base_dmg_min => 2, :base_dmg_max => 10}
      @interface = Ui.new(nil)
      @fight = Fight.new(@interface)
    end
    describe "fight" do
      it "should start a fight with a monster and after each round save" do
        YamlManage.stub!(:load_file)
        @interface.stub!(:battle_info)
        @interface.stub!(:fight_menu)
        @interface.stub!(:clear_console)
        @fight.stub!(:attack)
        @fight.stub!(:check_fight_end).and_return(true)
        YamlManage.stub!(:save_char)
        @fight.fight(@char, "Sin").should == nil
      end
    end
    
    describe "check if someone was defeated and give bonus or penalty to player" do
      it "should return defeated? true because one entity has 0 hp" do
        @fight.stub!(:player_penalty)
        @fight.check_fight_end({:hp => 0}, {:hp => 20}).should == true
      end
      
      it "should return defeated? true because another entity has 0 hp" do
        @fight.stub!(:player_prize)
        @fight.check_fight_end({:hp => 10}, {:hp => 0}).should == true
      end
      
      it "should return defeated? false because both entitys has more hp than 0" do
        @fight.check_fight_end({:hp => 10}, {:hp => 20}).should == false
      end
    end
    
    describe "bonus" do
      it "should give character a bonus of 30 exp points and 3 gold" do
        a = mock("Random", {:rand => 3})
        Random.stub!(:new).and_return(a)
        @interface.stub(:winner_msg)
        @fight.player_prize( @char, {:exp_bonus => 30, :gold_max => 100})
        @char[:exp].should == 40
        @char[:gold].should == 303
      end
    end
    
    describe "penalty" do
      it "should decrease characters exp by " do
        a = mock("Random", {:rand => 30})
        Random.stub!(:new).and_return(a)
        @interface.stub(:looser_msg)
        @fight.player_penalty(@char, {:exp_bonus => 30, :gold_max => 100})
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
        @fight.attack(@char, @char)
        @char[:hp].should == 99
      end
    end
    
    describe "skill attack" do
      it "should decrease defenders health points by attackers doubled maximum damage" do
        @fight.skill(@char, @char)
        @char[:hp].should == 80
      end
    end
    
    describe "use item" do
      it "should increase attackers health points by 10" do
        @fight.use_item(@char)
        @char[:hp].should be_equal(110)
      end
    end
  end