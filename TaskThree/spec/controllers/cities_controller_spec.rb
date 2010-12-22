require 'spec_helper.rb'

describe CitiesController do
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
  end
  describe "wilds" do
    it "should return all city fight areas" do
      
      get :wilds
      
      assigns[:wilds].should == @city.fight_areas
     
    end
  end
  
  describe "inn" do
    it "should let user rest" do
      @avatar.hp = 1
      get :inn
      @avatar.reload.hp.should == @avatar.max_hp
    end
  end



end