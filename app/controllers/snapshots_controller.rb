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
    #snapshot {:user_id => "1", :like_count => 1, :unlike_count => 1, :flag_count => 1, etc., :snapshot_path {:file => "base64 encoded awesomeness", :original_filename => "my file name", :filename => "my file name"}}

    puts "JHRLOG: inside shapshot create"
    puts "JHRLOG: dumping params..."
    puts params.inspect
    puts "JHRLOG: end dumping params..."

    #check if file is within picture_path
    if params[:snapshot][:snapshot_path]["file"]
      puts "JHRLOG: found a file entry"


      snapshot_path_params = params[:snapshot][:snapshot_path]

      #create a new tempfile named fileupload

      tempfile = Tempfile.new("snapshot.jpg", Rails.root.join('tmp','snapshot-temp'))
      tempfile.binmode

      base64file = snapshot_path_params["file"].partition(',').last


      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(base64file))

      #create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => snapshot_path_params["snapshot.jpg"], :original_filename => snapshot_path_params["snapshot.jpg"])

      #replace photo element with the new uploaded file
      params[:snapshot][:photo] = uploaded_file
    end

    puts "JHRLOG: after the base64 file processing"

    @snapshot = Snapshot.new(snapshot_params)
    @snapshot.save
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
