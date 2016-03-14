class UsersController < ApplicationController
  #before_action :authenticate_user!
  #before_action :admin_only, :except => :show

  def index
    @users = User.all
  end

   def new

    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Undercontrol!"
      redirect_to controller: 'dashboard', action: 'index' 
    else
      flash[:danger] = "There were problems with your registration."
      render "new"
    end
    
  end


 

  def show

    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

    def user_params
        params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
    end

    def admin_only
      unless current_user.admin?
        redirect_to :back, :alert => "Access denied."
      end
    end

    def secure_params
      params.require(:user).permit(:role)
    end

end
