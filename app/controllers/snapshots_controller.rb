class SnapshotsController < ApplicationController
  before_action :set_snapshot, only: [:show, :edit, :update, :destroy]

  def index
    @snapshots = Snapshot.all
    respond_with(@snapshots)
  end

  def show
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
    @snapshot.save

    # puts "JHRLOG: new snapshot is created, lacking the image"

    #check if file is within picture_path
    if params[:snapshot][:snapshot_path]["snapshot_file"]
      # puts "JHRLOG: found a file entry"


      snapshot_path_params = params[:snapshot][:snapshot_path]

      #create a new tempfile named fileupload

      tempfile = Tempfile.new("snapshot.jpg", Rails.root.join('tmp'))

      # puts"JHRLOG: tempfile opened at #{tempfile.path}"

      tempfile.binmode
      # puts"JHRLOG: tempfile binmode set"

      # the buffer may be coming in with a base64 descriptor... trim it off the front
      # base64file = snapshot_path_params["snapshot_file"].partition(',').last
      base64file = snapshot_path_params["snapshot_file"]


      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(base64file))

      # puts "JHRLOG: tempfile size after decode64 is #{tempfile.size}"

      #create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => "snapshot.jpg", :original_filename => "snapshot.jpg")

      # puts "JHRLOG: uploaded file object has been created "

      #replace photo element with the new uploaded file
      # params[:snapshot][:photo] = uploaded_file

      @snapshot.photo = uploaded_file

      # puts "JHRLOG: snapshot has been assigned an upload image"
      if @snapshot.save
        # puts "JHRLOG: snapshot has been saved with the image"
        tempfile.unlink
      end


    end

    # puts "JHRLOG: after the base64 file processing"

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

  private
  def set_snapshot
    @snapshot = Snapshot.find(params[:id])
  end

  def snapshot_params
    params.require(:snapshot).permit(:URL, :like_count, :unlike_count, :flag_count, :user_id, :photo, :photo_cache)
  end
end
