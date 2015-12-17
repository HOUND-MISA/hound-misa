class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show, :search]
  before_filter :authenticate_owner, only: [:edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all.order('start_date ASC')
    @events = Event.paginate(:page => params[:page])
  end

  # GET /events/1
  # GET /events/1.json
  def show
    if user_signed_in?
      @attended = EventAttendee.where(['event_id = ? and user_id = ?',params[:id],current_user.id])
    end
    @attendees = EventAttendee.where(['event_id = ?',params[:id]])
    @last_three_attendees = @attendees.last(3)
    @hash = Gmaps4rails.build_markers(@event) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
    @event_tags = EventTag.where(['event_id = ?',params[:id]])
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    #@event.event_tags.build
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    #@event.event_tags.build
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def search
    @search = params['search_query']
    @tag = params['category']
    @city = params['city']
    @date = params['date']

    if @search != nil
      @events = Event.where(['name LIKE ? OR description LIKE ? OR id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name LIKE ?))',"%#{@search}%","%#{@search}%", "%#{@search}%"]).order('start_date ASC')
    else
      @events = Event.where(["id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?)) OR city = ? OR strftime('%m-%d-%Y',start_date) = ?","#{@tag}","#{@city}","#{@date}"]).order('start_date ASC')
    end
    render :template => "events/search"
    @events = Event.paginate(:page => params[:page])
  end

  def authenticate_owner
    @event = Event.find(params[:id])
    if current_user.id != @event.user_id
      redirect_to event_path(@event)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      #params.require(:event).permit(:name, :start_date, :end_date, :address, :website, :lat, :lon, :user_id)
      params.require(:event).permit!
    end
end
