class SchoolsController < ApplicationController
  respond_to :html, :json
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def index
    if params[:hs_search]
      hs_search = params[:hs_search]
      @schools = School.where("name LIKE ?",  "%#{hs_search}%").order(:name)
    else
      @schools = School.order(:name)

    end
    respond_with(@schools)
  end

  def show
    respond_with(@school)
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

  def members
    @school = School.find(params[:school_id])
    respond_with(@school)
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
