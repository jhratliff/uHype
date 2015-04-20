class UsersController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:reset_password]
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

      if (params[:user][:update_token])
        puts "New password: #{params[:user][:update_token]}"
        @user.update_password (params[:user][:update_token])
      else
        puts params
      end

      # update the text field based on the class_of data
      @user.year_text = @user.get_year_text
      @user.save

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

    @user.clear_badge

    # render :json => current_user

    puts ">>>>>> ME requested, returning First Name: #{@user.first_name}, Last Name: #{@user.last_name}, Email: #{@user.email}"

    save_user = false

    if (params[:loadme])
      if (params[:loadme][:version_number]) and (params[:loadme][:version_number] != @user.version_number)
        @user.version_number = params[:loadme][:version_number]
        save_user = true
      end

      if (params[:loadme][:status_code])
        @user.status_code = params[:loadme][:status_code]

        if (@user.status_code == "ok")
          @user.status_code = nil
          @user.action_code = nil
        end

        save_user = true
      end

      @user.save if save_user

    end

    respond_with(@user)
  end

  def friend
    # return our own record if we don't find the friend
    @user = current_user

    if params[:friend_id]
      @user = User.find(params[:friend_id])
    end

    puts ">>>>>> FRIEND requested, returning First Name: #{@user.first_name}, Last Name: #{@user.last_name}, Email: #{@user.email}"

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
    @current_user = current_user
    if(params[:user_id])
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
    @response = {:user => @user, :current_user => @current_user}

    respond_with(@response)
  end

  def followers
    @current_user = current_user
    if(params[:user_id])
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end

    @response = {:user => @user, :current_user => @current_user}
    respond_with(@response)
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

    @comments = Comment.where(:school => schools).order(:id => :desc).last(100)
    @user = current_user
    respond_with(@comments)


  end

  def near_me
    # puts ".... hit the near_me controller"
    if(params[:location][:latitude] and params[:location][:longitude] and params[:location][:distance])
      # puts ".... have enough params"
      @user = current_user

      @user.longitude = params[:location][:longitude]
      @user.latitude = params[:location][:latitude]
      @user.location_timestamp = Time.now.utc
      @user.save

      @users = User.where("is_location_private = ? AND school_id > ?", false, 0).where.not({:latitude => '',:longitude => ''}).all

      # puts ".... found #{@users.count} users, proceeding to render"
      respond_with(@users)

    end
  end

  def register_notifications
    @user = current_user

    if(params[:push_token])
      @user.push_token = params[:push_token]

      client = Aws::SNS::Client.new(region: 'us-west-2')
      response = client.create_platform_endpoint(
          platform_application_arn: "arn:aws:sns:us-west-2:844150499332:app/APNS/uHype",
          token: params[:push_token],
          custom_user_data: @user.email

      )
      @user.endpoint_arn = response[:endpoint_arn]
      @user.save
      puts ">>>>>>>>>>>>> token saved: #{params[:push_token]}"
    end
  end

  def unregister_notifications
    @user = current_user
    if(@user.push_token)
      @user.endpoint_arn = nil
      @user.push_token = nil
      @user.save
    end
  end


  def reset_password

    reason = 'bar reason'
    status = 'foo status'
    email_address = params[:lost_password_email]

    puts ("@@@@@@@@@@@ lost password email is: #{params[:lost_password_email]} ")

    if(!email_address.nil?)
      puts ("@@@@@@@@@@@ password is not nil ")

      status = 'Success'
      reason = "Check your email (#{email_address}) for the updated password"

    else
      puts ("@@@@@@@@@@@ password is nil ")
      status = 'Error'
      reason = 'Empty email address was sent'
    end

    @response = {:status => status, :reason => reason}

    respond_with(@response)

  end



  private

  def secure_params
    params.require(:user).permit(:role, :username, :password, :first_name, :last_name, :class_of, :school_id, :is_private, :is_location_private, :push_token, :status_code, :latitude, :longitude, :avatar, :avatar_cache)
    # not permitted to change from the outside.... :location_timestamp
  end

end
