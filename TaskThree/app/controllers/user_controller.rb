class UserController < ApplicationController
  
  def authenticate
    @user_t = Avatar.new(params[:userform])
    valid_user = Avatar.find(:first,:conditions => ["name = ? and password = ?",@user_t.name, @user_t.password])
    if valid_user
      session[:user_id]=valid_user.id
      redirect_to :action => 'private'
    else
      flash[:notice] = "Invalid User/Password"
      redirect_to :action=> 'login'
    end
  end

  def assign_class
    if (params[:c_class] == "warrior") 
      @user.class_warrior
    elsif (params[:c_class] == "archer")
      @user.class_archer
    elsif (params[:c_class] == "mage") 
      @user.class_mage
    end
    redirect_to :action => 'private'  
  end

  def login
  end
  
  def register
    if !session[:user_id]
      if params[:regform]
        @user_r = params[:regform]
        city = City.find_by_name("Ellion").id
        Avatar.create(:name => @user_r[:regname],
          :password => @user_r[:regpassword], 
          :avatar_class => 0,
          :level => 1,
          :exp => 0,
          :city_id => city,
          :gold => 100,
          :base_dmg_min => 0,
          :base_dmg_max => 0,
          :max_hp => 10,
          :hp => 10,
          :max_mana => 10,
          :mana => 10,
          )
          redirect_to :action => 'login'
      end      
    end
  end

  def private
    if !session[:user_id]
      redirect_to :action=> 'login'
    end
  end

  def logout
    if session[:user_id]
      reset_session
      redirect_to :action=> 'login'
    end
  end

end