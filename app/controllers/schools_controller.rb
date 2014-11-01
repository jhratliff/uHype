class SchoolsController < ApplicationController
  respond_to :html, :json
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def index
    @schools = School.order(:name)
    respond_with(@schools)
  end

  def show
    @response = {:school => @school, :user => current_user}
    respond_with(@response)
  end

  def new
    @school = School.new
    respond_with(@school)
  end

  def edit
  end

  def create
    @school = School.new(school_params)
    @school.save
    respond_with(@school)
  end

  def update
    @school.update(school_params)
    @school.logo = params[:file]
    @school.save
    respond_with(@school)
  end

  def follow
    @user = current_user
    if params[:school_id]
      @user.followed_schools << School.find(params[:school_id])
    end
  end

  def unfollow
    @user = current_user
    if params[:school_id]
      @user.followed_schools.destroy(School.find(params[:school_id]))
    end
  end

  def destroy
    @school.destroy
    respond_with(@school)
  end

  private
    def set_school
      @school = School.find(params[:id])
    end

    def school_params
      params.require(:school).permit(:name, :address, :city, :state, :zip, :maplink, :stype, :grades, :website, :logo, :logo_cache)
    end
end
