class TrackPointsController < ApplicationController
  before_action :set_track_point, only: [:show, :edit, :update, :destroy]

  # GET /track_points
  # GET /track_points.json
  def index
    @track_points = TrackPoint.all
  end

  # GET /track_points/1
  # GET /track_points/1.json
  def show
  end

  # GET /track_points/new
  def new
    @track_point = TrackPoint.new
  end

  # GET /track_points/1/edit
  def edit
  end

  # POST /track_points
  # POST /track_points.json
  def create
    @track_point = TrackPoint.new(track_point_params)

    respond_to do |format|
      if @track_point.save
        format.html { redirect_to @track_point, notice: 'Track point was successfully created.' }
        format.json { render :show, status: :created, location: @track_point }
      else
        format.html { render :new }
        format.json { render json: @track_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /track_points/1
  # PATCH/PUT /track_points/1.json
  def update
    respond_to do |format|
      if @track_point.update(track_point_params)
        format.html { redirect_to @track_point, notice: 'Track point was successfully updated.' }
        format.json { render :show, status: :ok, location: @track_point }
      else
        format.html { render :edit }
        format.json { render json: @track_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /track_points/1
  # DELETE /track_points/1.json
  def destroy
    @track_point.destroy
    respond_to do |format|
      format.html { redirect_to track_points_url, notice: 'Track point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track_point
      @track_point = TrackPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_point_params
      params.require(:track_point).permit(:latitude, :longitude, :index)
    end
end
