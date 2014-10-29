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

    @snapshot = Snapshot.new(snapshot_params)

    # presupposes this format:
    #snapshot {:user_id => "1", :like_count => 1, :unlike_count => 1, :flag_count => 1, etc., :snapshot_path {:file => "base64 encoded awesomeness", :original_filename => "my file name", :filename => "my file name"}}

    #check if file is within picture_path
    if params[:snapshot][:snapshot_path]["file"]
      snapshot_path_params = params[:snapshot][:snapshot_path]

      #create a new tempfile named fileupload
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode

      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(snapshot_path_params["file"]))

      #create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => snapshot_path_params["filename"], :original_filename => snapshot_path_params["original_filename"])

      #replace picture_path with the new uploaded file
      params[:snapshot][:snapshot_path] = uploaded_file
    end


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
