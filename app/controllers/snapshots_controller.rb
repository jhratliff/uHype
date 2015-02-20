class SnapshotsController < ApplicationController
  before_action :set_snapshot, only: [:show, :edit, :update, :destroy]

  def index
    @snapshots = Snapshot.all
    respond_with(@snapshots)
  end

  def show
    @user = current_user
    respond_with(@snapshot)
  end

  def new
    @snapshot = Snapshot.new
    respond_with(@snapshot)
  end

  def edit
  end

  def create


    # presupposes this format:
    #snapshot {:user_id => "1", :like_count => 1, :unlike_count => 1, :flag_count => 1, etc., :snapshot_path {:snapshot_file => "base64 encoded awesomeness", :original_filename => "my file name", :filename => "my file name"}}

    # puts "JHRLOG: inside shapshot create"
    # puts "JHRLOG: dumping params..."
    # puts params.inspect

    # puts "JHRLOG: end dumping params..."


    @snapshot = Snapshot.new(snapshot_params)
    @snapshot.user = current_user
    @snapshot.save

    # puts "JHRLOG: new snapshot is created, lacking the image"

    #check if file is within picture_path
    if params[:snapshot][:snapshot_image]["snapshot_file"]
      # puts "JHRLOG: found a file entry"


      snapshot_image_params = params[:snapshot][:snapshot_image]

      #create a new tempfile named fileupload

      tempfile = Tempfile.new("snapshot.jpg", Rails.root.join('tmp'))

      # puts"JHRLOG: tempfile opened at #{tempfile.path}"

      tempfile.binmode
      # puts"JHRLOG: tempfile binmode set"

      # the buffer may be coming in with a base64 descriptor... trim it off the front
      # base64file = snapshot_path_params["snapshot_file"].partition(',').last
      base64file = snapshot_image_params["snapshot_file"]


      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(base64file))

      puts "JHRLOG: tempfile size after decode64 is #{tempfile.size}"

      #create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => "snapshot.jpg", :original_filename => "snapshot.jpg")

      puts "JHRLOG: uploaded file object has been created "

      #replace photo element with the new uploaded file
      # params[:snapshot][:photo] = uploaded_file

      @snapshot.photo = uploaded_file

      puts "JHRLOG: snapshot has been assigned an upload image"
      if @snapshot.save
        puts "JHRLOG: snapshot has been saved with the image"
        tempfile.unlink
      end
    end

    # #process the video file if it exists
    # if params[:snapshot][:snapshot_video]["snapshot_file"]
    #   # puts "JHRLOG: found a file entry"
    #
    #   snapshot_video_params = params[:snapshot][:snapshot_video]
    #
    #   #create a new tempfile named fileupload
    #
    #   tempfile = Tempfile.new("snapshot.mov", Rails.root.join('tmp'))
    #
    #   # puts"JHRLOG: tempfile opened at #{tempfile.path}"
    #
    #   tempfile.binmode
    #   # puts"JHRLOG: tempfile binmode set"
    #
    #   # the buffer may be coming in with a base64 descriptor... trim it off the front
    #   # base64file = snapshot_path_params["snapshot_file"].partition(',').last
    #   base64file = snapshot_video_params["snapshot_file"]
    #
    #
    #   #get the file and decode it with base64 then write it to the tempfile
    #   tempfile.write(Base64.decode64(base64file))
    #
    #   # puts "JHRLOG: tempfile size after decode64 is #{tempfile.size}"
    #
    #   #create a new uploaded file
    #   uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => "snapshot.mov", :original_filename => "snapshot.mov")
    #
    #   # puts "JHRLOG: uploaded file object has been created "
    #
    #   #replace photo element with the new uploaded file
    #   # params[:snapshot][:photo] = uploaded_file
    #
    #   @snapshot.video = uploaded_file
    #
    #   # puts "JHRLOG: snapshot has been assigned an upload image"
    #   if @snapshot.save
    #     # puts "JHRLOG: snapshot has been saved with the image"
    #     tempfile.unlink
    #   end
    # end
    #
    puts "JHRLOG: after the base64 file processing"

    respond_with(@snapshot)
  end



  def update
    @snapshot.update(snapshot_params)
    @snapshot.photo = params[:file]
    @snapshot.save
    respond_with(@snapshot)
  end

  def destroy
    @snapshot.destroy
    respond_with(@snapshot)
  end







  def flag
    @user = current_user
    if params[:snapshot_id]
      @user.flagged_snapshots << Snapshot.find(params[:snapshot_id])
    end
    @snapshot = Snapshot.find(params[:snapshot_id])
  end

  def unflag
    @user = current_user
    if params[:snapshot_id]
      @user.flagged_snapshots.destroy(Snapshot.find(params[:snapshot_id]))
    end
    @snapshot = Snapshot.find(params[:snapshot_id])
  end


  def like
    @user = current_user
    if params[:snapshot_id]
      @user.liked_snapshots << Snapshot.find(params[:snapshot_id])
    end
    @snapshot = Snapshot.find(params[:snapshot_id])
    @snapshot.like_count = @snapshot.snapshot_likes.count
    @snapshot.save
  end

  def unlike
    @user = current_user
    if params[:snapshot_id]
      @user.liked_snapshots.destroy(Snapshot.find(params[:snapshot_id]))
    end
    @snapshot = Snapshot.find(params[:snapshot_id])
    @snapshot.like_count = @snapshot.snapshot_likes.count
    @snapshot.save
  end

  def dislike
    @user = current_user
    if params[:snapshot_id]
      @user.unliked_snapshots << Snapshot.find(params[:snapshot_id])
    end
    @snapshot = Snapshot.find(params[:snapshot_id])
    @snapshot.unlike_count = @snapshot.snapshot_unlikes.count
    @snapshot.save
  end

  def undislike
    @user = current_user
    if params[:snapshot_id]
      @user.unliked_snapshots.destroy(Snapshot.find(params[:snapshot_id]))
    end
    @snapshot = Snapshot.find(params[:snapshot_id])
    @snapshot.unlike_count = @snapshot.snapshot_unlikes.count
    @snapshot.save
  end




  # GET snapshots/:snapshot_id/feed
  def feed
    # returns the snapshot's feed

    if params[:snapshot_id]
      @snapshot_comments = Snapshot.find(params[:snapshot_id]).snapshot_comments.order(:id => :desc).last(100)
    end

    respond_with(@snapshot_comments)

  end











  private
  def set_snapshot
    @snapshot = Snapshot.find(params[:id])
  end

  def snapshot_params
    params.require(:snapshot).permit(:URL, :like_count, :unlike_count, :flag_count, :user_id, :photo, :photo_cache, :video, :video_cache)
  end
end
