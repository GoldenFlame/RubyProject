require 'spec_helper.rb'

describe ShopsController do
  render_views
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    build :city2

    #build :shop

    @monster     = @city.fight_areas[0].monsters[0]
    @avatar.city = @city


    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
    @avatar.save
    session[:user_id] = @avatar.id
  end
  describe "index" do
    it "should redirect to buy" do
      get :index, :buy => 1
      response.should redirect_to(:action => 'buy')
    end
    it "should redirect to sell" do
      get :index, :sell => 1
      response.should redirect_to(:action => 'sell')
    end
    it "should redirect to users page" do
      get :index, :back => 1
      response.should redirect_to(:controller => 'user', :action => 'private')
    end
  end

  describe "buy" do
    it "should show all items in the shop" do
      get :buy
      assigns[:item_list].should == @avatar.city.shop.items
    end
  end

  describe "view" do
    it "should display item weapon" do
      get :view, :item => @item_weapon.id, :for => 'buy'
      assigns[:item].should == @item_weapon
    end
  end

  describe "buy item" do
    it "should redirect to buy" do
      get :buy_item, :item => @item_weapon.id
      response.should redirect_to(:action => 'buy')
    end

    it "should add item to avatars backpack" do
      get :buy_item, :item => @item_weapon.id
      @avatar.items.reload.should have(5).items
    end
  end

  describe "buy" do
    it "should show all items in the shop" do
      get :sell, :item => @item_weapon.id
      assigns[:item_list].should == @avatar.avatar_items
    end
  end

  describe "sell item" do
    it "should redirect to sell" do
      get :sell_item, :item => @item_weapon.id
      response.should redirect_to(:action => 'sell')
    end

    it "should add item to avatars backpack" do
      get :sell_item, :item => @item_weapon.id
      @avatar.reload.items.should have(5).items
    end
  end


end