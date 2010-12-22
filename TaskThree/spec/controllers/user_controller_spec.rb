require 'spec_helper.rb'

describe UserController do
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
  
  describe "registration" do
    it "should create new avatar loki" do
      a = mock("City", {:id => @city.id})
      City.stub!(:find_by_name).and_return(a)
      session[:user_id] = nil
      post :register, :regform => {:regname => 'loki', :regpassword => 'loki'}
      Avatar.find_by_name('loki').should_not == nil
    end
  end
  
  describe "authenticate" do
    it "redirect to private" do
      get :authenticate, :userform => {:name => 'test', :password => 'test'}
      response.should redirect_to(:action => 'private')
    end
    it "redirect to login" do
      get :authenticate, :userform => {:name => 'test', :password => 'testds'}
      response.should redirect_to(:action => 'login')
    end
  end
 
  describe "private" do
    it "should redirect to login" do
      session[:user_id] = nil
      get :private
      response.should redirect_to(:action => 'login')
    end
  end

  describe "logout" do
    it "should redirect to login" do
      get :logout
      response.should redirect_to(:action => 'login')
    end
  end

end