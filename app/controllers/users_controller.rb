class UsersController < ApplicationController
  
  before_filter :authenticate, :except => [:show, :new, :create]
  #before_filter :authenticate, :only => [:index,:edit, :update, :destroy], :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def destroy
    victim = User.find(params[:id])
    if victim == current_user
      flash[:error] = "You can't just quit. Haven't you read the terms?"
      redirect_to users_path
    else
      victim.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end
  
 def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def new
    if current_user
      flash[:notice] = "Don't try to create more than one account sucker!"
      redirect_to root_path
    else
      @user = User.new
      @title = "Sign up"
    end
  end
    
  def create
   @user = User.new(params[:user])
   if @user.save
     sign_in @user
     flash[:success] = "Welcome to the Sample App!"
     redirect_to @user
   else
     @title = "Sign up"
     @user.password.clear
     @user.password_confirmation.clear
     render 'new'
   end
 end
 
 def edit
   @user = User.find(params[:id])
   @title = "Edit user"
 end
 
 def update
   @user = User.find(params[:id])
   if @user.update_attributes(params[:user])
     flash[:success] = "Profile updated."
     redirect_to @user
   else
     @title = "Edit user"
     render 'edit'
   end
 end
 
 private
 
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
  
end