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
    @snapshot.save
    respond_with(@snapshot)
  end

  def update
    @snapshot.update(snapshot_params)
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
      params.require(:snapshot).permit(:URL, :like_count, :unlike_count, :flag_count, :user_id)
    end
end
