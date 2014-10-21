class UsersController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!
  # after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      # redirect_to users_path, :notice => "User updated."
      respond_with(@user);
    else
      respond_with(@user.errors, :status => :unprocessable_entity) do |format|
        format.html { render :action => :new }
      end
      # redirect_to users_path, :alert => "Unable to update user."

    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def me
    @user = current_user
    # render :json => current_user
    respond_with(@user)
  end

  private

  def secure_params
    params.require(:user).permit(:role, :first_name,:last_name,:dob, :class_of, :school_id)
  end

end
