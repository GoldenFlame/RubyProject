require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
  describe "fight system" do
    before(:each) do
      build :avatar
      build :item_armor
      build :item_weapon
      build :item_armor2
      build :item_weapon2
      build :city
      
      @avatar.backpack_init
      @monster = @city.fight_areas[0].monsters[0]
      @interface = Ui.new(nil)
      @fight = Fight.new(@interface)
    end
    describe "fight" do
      it "should initiate a fight with a monster sin" do
        @interface.stub!(:battle_info)
        @interface.stub!(:fight_menu)
        @interface.stub!(:clear_console)
        @fight.stub!(:attack).and_return(true)
        @fight.stub!(:check_fight_end).and_return(true)
        @fight.fight(@avatar, @monster).should == nil
      end
    end
    
    describe "check if someone was defeated and give bonus or penalty to player" do
      it "should give player penalty" do
        @avatar.hp = 0
        @fight.stub!(:player_penalty)
        @fight.check_fight_end(@avatar, @monster).should == true
      end
      
      it "should give player a bonus" do
        @monster.hp = 0
        @fight.stub!(:player_prize)
        @fight.check_fight_end(@avatar, @monster).should == true
      end
      
      it "should do nothing" do
        @fight.check_fight_end(@avatar, @monster).should == false
      end
    end
    
    describe "bonus" do
      it "should give avatar a bonus of 10 exp points and 3 gold" do
        a = mock("Random", {:rand => 3})
        Random.stub!(:new).and_return(a)
        @interface.stub(:winner_msg)
        @fight.player_prize( @avatar, @monster)
        @avatar.exp.should == 10
        @avatar.gold.should == 103
      end
    end
    
    describe "penalty" do
      it "should decrease avatars gold by 3 " do
        a = mock("Random", {:rand => 30})
        Random.stub!(:new).and_return(a)
        @interface.stub(:looser_msg)
        @fight.player_penalty(@avatar, @monster)
        @avatar.gold.should == 97
      end
    end
    
    describe "attack" do
      
      it "should decrease monsters health points by 1 when avatar has no weapon" do
        #damage is calculated by taking random number in range of avataracters min damage and max damage
        #therefor mock object a returning value 1 instead of random
        a = mock("Random", {:rand => 1})
        Random.stub!(:new).and_return(a)
        @fight.attack(@avatar, @monster)
        @monster.hp.should == 99
      end
      
      it "should decrease monsters health points by 2 when avatar has a weapon" do
        #damage is calculated by taking random number in range of avataracters min damage and max damage
        #therefor mock object a returning value 1 instead of random
        a = mock("Random", {:rand => 2})
        Random.stub!(:new).and_return(a)
        @avatar.eq_weapon = @item_weapon
        @fight.attack(@avatar, @monster)
        @monster.hp.should == 98
      end
      
      it "should decrease avatars health points by 10 when avatar has no armor" do
        a = mock("Random", {:rand => 10})
        Random.stub!(:new).and_return(a)
        @avatar.hp = 100
        @fight.attack(@monster, @avatar)
        @avatar.hp.should == 90
      end
      
      it "should decrease avatars health points by 48 when avatar has armor" do
        a = mock("Random", {:rand => 50})
        Random.stub!(:new).and_return(a)
        @avatar.hp = 100
        
        @avatar.eq_armor = @item_armor
        @fight.attack(@monster, @avatar)
        @avatar.hp.should == 52
      end
    end
    
    describe "skill attack" do
      it "should decrease defenders health points by 20" do
        @avatar.base_dmg_max = 10
        @fight.skill(@avatar, @monster)
        
        @monster.hp.should == 80
      end
    end
    
    describe "use item" do
      it "should increase avatars health points by 10" do
        @avatar.hp = 0
        @fight.use_item(@avatar)
        @avatar.hp.should be_equal(10)
      end
    end
  end