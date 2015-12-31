class HomeController < ApplicationController

def home
@activities = Activity.order("created_at DESC").page(params[:page]).per_page(5)

end

def login
	render 
end

def logout
session[:school_id] = nil
session[:parent_id] = nil
session[:user_id] = nil
redirect_to root_path
end

  def attempt_login

    #check whether user has provided username and password
    if params[:username].present? && params[:password].present?
      found_user = SchoolUser.where(:login_id => params[:username]).first
      if found_user 
        #decrypt password (bcrypt gem is used)
        authorized_user = found_user.authenticate(params[:password])
      end
    end

    #check for authorized_user and store the values into session
    if authorized_user
      
      session[:role_id] = authorized_user.role_id
      session[:user_id] = authorized_user.id
      session[:school_id] = authorized_user.school_id
      session[:username] = authorized_user.first_name + " " +authorized_user.last_name

        if session[:role_id] == 2
          redirect_to(:controller => 'school_users' ,:action => 'teacherHomeView')
          
          else
          flash[:notice] = "You are now logged in."
          redirect_to new_activity_path
        end
    #else condition for authorized_user
    else 
      flash[:notice] = "Invalid username/password combination."
      redirect_to('login')
    end

  end

end
