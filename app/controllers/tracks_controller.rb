class TracksController < ApplicationController
  # include TracksHelper
  before_action :set_track, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]

  # GET /tracks
  # GET /tracks.json
  def index
    @tracks = Track.active
    if params[:with_points] == 'true'
      @tracks.includes :track_points
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
  end

  # GET /tracks/new
  def new
    @track = Track.new
  end

  # GET /tracks/1/edit
  def edit
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(track_params)

    respond_to do |format|
      if !params[:track_track].blank? &&
         !params[:track_starts].blank? &&
         !params[:track_ends].blank? &&
         @track.save
        params[:track_track].split(';').each_with_index do |point, i|
          point = point.split(',')
          @track.track_points.create latitude: point[0].to_f,
                                     longitude: point[1].to_f,
                                     index: i
        end

        params[:track_starts].split(';').each_with_index do |point, i|
          point = point.split(',')
          @track.starts[i].update! latitude: point[0].to_f,
                                   longitude: point[1].to_f
        end

        params[:track_ends].split(';').each_with_index do |point, i|
          point = point.split(',')
          @track.ends[i].update! latitude: point[0].to_f,
                                 longitude: point[1].to_f
        end

        format.html { redirect_to root_path, notice: 'Strecke wurde erfolgreich erstellt!' }
        format.json { render :show, status: :created, location: @track }
      else
        flash[:error] = 'Keine Strecke angegeben.' if params[:track_track].blank?
        format.html { render :new }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracks/1
  # PATCH/PUT /tracks/1.json
  def update
    respond_to do |format|
      if !params[:track_track].blank? &&
         !params[:track_starts].blank? &&
         !params[:track_ends].blank? &&
         @track.update(track_params)
        i = 0
        @track.track_points.map(&:delete)
        params[:track_track].split(';').each do |point|
          point = point.split(',')
          @track.track_points.create latitude: point[0].to_f,
                                     longitude: point[1].to_f,
                                     index: i
          i += 1
        end

        @track.starts.map(&:delete)
        params[:track_starts].split(';').each do |point|
          point = point.split(',')
          @track.starts.create latitude: point[0].to_f,
                               longitude: point[1].to_f
        end

        @track.ends.map(&:delete)
        params[:track_ends].split(';').each do |point|
          point = point.split(',')
          @track.ends.create latitude: point[0].to_f,
                             longitude: point[1].to_f
        end
        format.html { redirect_to @track, notice: 'Die Strecke wurde erfolgreich aktualisiert.' }
        format.json { render :show, status: :ok, location: @track }
      else
        format.html { render :edit }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Die Strecke wurde erfolgreich gelöscht.' }
      format.json { head :no_content }
    end
  end

  private

  def set_track
    @track = Track.find(params[:id])
  end

  def track_params
    params.require(:track).permit(:name, :distance, :time, :link, :track,
      start_times_attributes: [:id, :is_repeated, :day_of_week, :date, :time, :_destroy],
      starts_attributes: [:id, :description, :time, :_destroy],
      ends_attributes: [:id, :description, :time, :_destroy])
  end
end
