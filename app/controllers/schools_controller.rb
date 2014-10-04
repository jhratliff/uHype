class SchoolsController < ApplicationController
  respond_to :html, :json
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def index
    @schools = School.order(:id).all
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
