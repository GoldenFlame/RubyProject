require 'spec_helper.rb'

describe AvatarController do
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
    session[:user_id] = @avatar.id
    @avatar.city = @city
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
  end
  describe "travel" do
    
    it "should be successful" do
      get 'travel'
      response.should be_success
    end
    
    it "should return all cities" do
      get 'travel'
      assigns[:cities].should == [@city, @city2]
    end
    
    it "should assign user city2" do
      
      get :travel, :dest => @city2.id
      @avatar.reload.city.should == @city2
    end
    
    it "should redirect to users page" do
      session[:user_id] = @avatar.id
      get :travel, :dest => @city2.id
      response.should redirect_to(:controller => 'user',:action => 'private')
    end
  end
  
  describe "item" do
    it "should return item_weapon" do
      get :item, :avatar_item => @item_weapon.id
      assigns[:item].should == @item_weapon
    end
  end
  
  describe "inventory" do
    it "should return all avatars items" do
      get :inventory
      assigns[:items].should have(5).items
    end
  end
  
  describe "equip" do
    it "should redirect to inventory" do
      get :equip, :item => @item_weapon
      response.should redirect_to(:action => 'inventory')
    end
  end
  
  describe "disequip" do
    it "should disequip weapon" do
      @avatar.equip(@item_weapon)
      get :disequip, :weapon => '1'
      @avatar.reload.weapon.should == nil
    end
    it "should disequip armor" do
      @avatar.equip(@item_armor)
      get :disequip, :armor => '1'
      @avatar.reload.armor.should == nil
    end
    it "should redirect to stats" do
      get :disequip
      response.should redirect_to(:action => 'stats')
    end
  end
end