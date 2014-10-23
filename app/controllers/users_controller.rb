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

  def feed
    # returns the user's feed
    # feed items are the most recent items from all the schools I follow (including my own school)
    # feed items include:
    # User's Full Record (including High School name)
    # Post Date
    # likes_count
    # unlikes_count
    #
    # AND
    #
    # the same data for all the individuals I follow (their posts)




  end

  private

  def secure_params
    params.require(:user).permit(:role, :first_name,:last_name,:dob, :class_of, :school_id)
  end

end
