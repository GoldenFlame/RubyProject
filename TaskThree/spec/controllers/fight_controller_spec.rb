require 'spec_helper.rb'
require 'test/unit'
require 'mocha'
describe FightController do
  render_views
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    build :city2

    @monster = @city.fight_areas[0].monsters[0]
    @avatar.city = @city
    
    
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
    @avatar.save
    session[:user_id] = @avatar.id
    @avatar.create_fight(:monster_id => @monster.id, 
      :monster_hp => @monster.hp,
      :ended => false,
      :fight_area_id => @avatar.city.fight_areas[0].id)
      @avatar.save
      @avatar.reload
  end
  describe "check fight end" do
    it "should redirect to area" do
      get :check_fight_end
      response.should redirect_to(:action => 'area', :area => @avatar.fight.fight_area_id)
    end
  end
  
  describe "area" do
    it "should create a fight" do
      post :area
      @avatar.reload.fight.should_not == nil
    end
  end
  
  describe "user action" do
    it "should call attack" do
      Avatar.any_instance.expects(:attack).at_least(1)
      post :user_action, :attack => 1
    end
      
      
    it "should redirect to check fight end" do
      Avatar.any_instance.expects(:skill_attack).at_least(1)
      post :user_action, :skill_attack => 1
    end
    
    it "should redirect to check fight end" do
      Avatar.any_instance.expects(:heal).at_least(1)
      post :user_action, :heal => 1
    end
    
    it "should redirect to check fight end" do
      post :user_action, :attack => 1
      response.should redirect_to(:action => 'check_fight_end')
    end
    
    it "should redirect to check fight end" do
      Avatar.any_instance.expects(:skill_attack).at_least(1)
      post :user_action, :skill_attack => 1
      response.should redirect_to(:action => 'check_fight_end')
    end
    
    it "should redirect to check fight end" do
      Avatar.any_instance.expects(:heal).at_least(1)
      post :user_action, :heal => 1
      response.should redirect_to(:action => 'check_fight_end')
    end
    
    it "should redirect to check fight end" do
      post :user_action, :back => 1
      response.should redirect_to(:controller => 'user', :action => 'private')
    end
  end
  


end