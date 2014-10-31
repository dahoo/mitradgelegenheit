class WayPointsController < ApplicationController
  before_action :set_way_point, only: [:show, :edit, :update, :destroy]

  # GET /way_points
  # GET /way_points.json
  def index
    @way_points = WayPoint.all
  end

  # GET /way_points/1
  # GET /way_points/1.json
  def show
  end

  # GET /way_points/new
  def new
    @way_point = WayPoint.new
  end

  # GET /way_points/1/edit
  def edit
  end

  # POST /way_points
  # POST /way_points.json
  def create
    @way_point = WayPoint.new(way_point_params)

    respond_to do |format|
      if @way_point.save
        format.html { redirect_to @way_point, notice: 'Way point was successfully created.' }
        format.json { render :show, status: :created, location: @way_point }
      else
        format.html { render :new }
        format.json { render json: @way_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /way_points/1
  # PATCH/PUT /way_points/1.json
  def update
    respond_to do |format|
      if @way_point.update(way_point_params)
        format.html { redirect_to @way_point, notice: 'Way point was successfully updated.' }
        format.json { render :show, status: :ok, location: @way_point }
      else
        format.html { render :edit }
        format.json { render json: @way_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /way_points/1
  # DELETE /way_points/1.json
  def destroy
    @way_point.destroy
    respond_to do |format|
      format.html { redirect_to way_points_url, notice: 'Way point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_way_point
      @way_point = WayPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def way_point_params
      params.require(:way_point).permit(:track_id, :latitude, :longitude, :description)
    end
end
