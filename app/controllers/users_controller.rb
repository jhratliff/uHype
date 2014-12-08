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

      #check if file is within picture_path
      if params[:avatar]
        # puts "JHRLOG: found a file entry"


        avatar_path_params = params[:avatar][:avatar_path]

        #create a new tempfile named fileupload

        tempfile = Tempfile.new("avatar.jpg", Rails.root.join('tmp'))

        # puts"JHRLOG: tempfile opened at #{tempfile.path}"

        tempfile.binmode
        # puts"JHRLOG: tempfile binmode set"

        # the buffer may be coming in with a base64 descriptor... trim it off the front
        # base64file = snapshot_path_params["snapshot_file"].partition(',').last
        base64file = avatar_path_params["avatar_file"]


        #get the file and decode it with base64 then write it to the tempfile
        tempfile.write(Base64.decode64(base64file))

        # puts "JHRLOG: tempfile size after decode64 is #{tempfile.size}"

        random_filename = (Time.now.to_f * 1000).to_s + ".jpg"

        #create a new uploaded file
        uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => random_filename, :original_filename => random_filename)

        # puts "JHRLOG: uploaded file object has been created "

        #replace photo element with the new uploaded file
        # params[:snapshot][:photo] = uploaded_file

        @user.avatar = uploaded_file

        # puts "JHRLOG: avatar has been assigned an upload image"
        if @user.save
          # puts "JHRLOG: avatar has been saved with the image"
          tempfile.unlink
        end
      end

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


  def follow
    @user = current_user

    if params[:user_id]

      @followed = User.find(params[:user_id])
      # @following = @user.followeds.where(:user => @requestor)
      @following = Following.new
      @following.user = @user
      @following.followed = @followed

      if @followed.is_private
        puts "current_user is private"
        @following.status = "requested"
      else
        # @user.friends << User.find(params[:user_id])
        puts "current_user is public"
        @following.status = "approved"
      end

      @following.save

    end

  end

  def unfollow
    @user = current_user
    if params[:user_id]
      @user.friends.destroy(User.find(params[:user_id]))
    end
  end

  def friends
    @user = current_user
    respond_with(@user)
  end

  def followers
    @user = current_user
    respond_with(@user)
  end

  # GET /users/:user_id/media
  def media

    if(params[:user_id])
      user = User.find(params[:user_id])
    else
      user = current_user
    end

    @snapshots = user.snapshots

    respond_with(@snapshots)

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

    schools = current_user.followed_schools

    @comments = Comment.where(:school => schools).order(:id).last(100)
    @user = current_user
    respond_with(@comments)


  end

  private

  def secure_params
    params.require(:user).permit(:role, :first_name, :last_name, :dob, :class_of, :school_id, :is_private, :is_location_private, :latitude, :longitude, :avatar, :avatar_cache)
    # not permitted to change from the outside.... :location_timestamp
  end

end
