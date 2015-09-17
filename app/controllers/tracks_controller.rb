class TracksController < ApplicationController
  # include TracksHelper
  before_action :set_track, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_edit_right, only: [:edit, :update, :destroy]

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
    @track.user = current_user

    respond_to do |format|
      if !params[:track][:points].blank? && @track.save
        @track.add_track_points(params[:track][:points])

        format.html { redirect_to @track, notice: 'Strecke wurde erfolgreich erstellt!' }
        format.json { render :show, status: :created, location: @track }
      else
        flash[:error] = 'Keine Strecke angegeben.' if params[:points].blank?
        format.html { render :new }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracks/1
  # PATCH/PUT /tracks/1.json
  def update
    respond_to do |format|
      if !params[:track][:points].blank? && @track.update(track_params)
        @track.add_track_points(params[:track][:points])

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

  def ensure_edit_right
    unless @track.user_id == current_user.id || current_user.admin?
      redirect_to root_path, flash: { error: 'Aktion nicht erlaubt.' }
    end
  end

  def track_params
    params.require(:track).permit(:name, :distance, :time, :link, :category,
      start_times_attributes: [:id, :is_repeated, :every, :day_of_week, :date, :time, :_destroy],
      starts_attributes: [:id, :description, :time, :latitude, :longitude, :_destroy],
      ends_attributes: [:id, :description, :time, :latitude, :longitude, :_destroy])
  end
end
