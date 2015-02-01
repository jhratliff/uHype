class SnapshotCommentsController < ApplicationController
  before_action :set_snapshot_comment, only: [:show, :edit, :update, :destroy]

  def index
    @snapshot_comments = SnapshotComment.all
    respond_with(@snapshot_comments)
  end

  def show
    respond_with(@snapshot_comment)
  end

  def new
    @snapshot_comment = SnapshotComment.new
    respond_with(@snapshot_comment)
  end

  def edit
  end

  def create
    @snapshot_comment = SnapshotComment.new(snapshot_comment_params)
    flash[:notice] = 'SnapshotComment was successfully created.' if @snapshot_comment.save
    respond_with(@snapshot_comment)
  end

  def update
    flash[:notice] = 'SnapshotComment was successfully updated.' if @snapshot_comment.update(snapshot_comment_params)
    respond_with(@snapshot_comment)
  end

  def destroy
    @snapshot_comment.destroy
    respond_with(@snapshot_comment)
  end

  private
    def set_snapshot_comment
      @snapshot_comment = SnapshotComment.find(params[:id])
    end

    def snapshot_comment_params
      params.require(:snapshot_comment).permit(:user_id, :snapshot_id, :detail)

      # params[:snapshot_comment]
    end
end
