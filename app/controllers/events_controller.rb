class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user, except: [:index, :show, :search, :edit, :approve, :reject]
  before_filter :authenticate_owner, only: [:edit, :update]
  before_filter :restrict_admin, only: [:new, :edit, :create, :update]
  before_filter :authenticate_admin, only: [:approve, :reject]
  before_action :for_index, only: [:index, :create]
  before_action :for_show, only: [:show, :update]

  # GET /events
  # GET /events.json
  def index
    if !current_user.try(:admin?)
      @event = Event.new
    end
    @ad = Ad.order("RANDOM()").first
    @open_ad = true
  end

  # GET /events/1
  # GET /events/1.json
  def show
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
        @reopen = true
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.html { render :index }
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
        @event.update(status: "Pending")
      else
        @reopen = true
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.html { render :show }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    if (current_user.try(:admin?)) || (current_user.try(:id) == @event.user_id)
      @event.destroy
      respond_to do |format|
        format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to event_path(@event)
    end
  end

def search
  @event = Event.new
  @header = "New Event"
  @submit = "Create Event"
  @search = params['search_query']
  @tag = params['category']
  @city = params['city']
  @date = params['date']

  if current_user.try(:admin?)
    @pending = Event.send(:sanitize_sql_array,['case when status = ? then 0 else 1 end',"Pending"])
    if @search != nil
      @events = Event.where(['name LIKE ? OR description LIKE ? OR id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name LIKE ?))',"%#{@search}%","%#{@search}%", "%#{@search}%"]).order(@pending).order('start_date ASC').paginate(:page => params[:page])
    else
      #for sqlite, use @events = Event.where(["id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?)) OR city = ? OR strftime(?,start_date) = ?","#{@tag}","#{@city}",'%Y-%m-%d',"#{@date}"]).order(@pending).order('start_date ASC').paginate(:page => params[:page])
      #@events = Event.where(["id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?)) OR city = ? OR to_char(start_date,?) = ?","#{@tag}","#{@city}",'YYYY-MM-DD',"#{@date}"]).order(@pending).order('start_date ASC').paginate(:page => params[:page])
      
      #for sqlite, use @events = Event.where(["id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?)) OR city = ? OR (strftime(?,start_date) = ?) OR (strftime(?, end_date) = ?) OR (? BETWEEN strftime(?,start_date) AND strftime(?,end_date))","#{@tag}","#{@city}",'%m',"#{@date}",'%m',"#{@date}","#{@date}",'%m','%m']).order(@pending).order('start_date ASC').paginate(:page => params[:page])
      @events = Event.where(["id IN 
        (SELECT event_id FROM event_tags where tag_id IN 
          (SELECT id FROM tags WHERE name = ?)) OR city = ? OR 
      (to_char(start_date,?) = ?) OR 
      (to_char(end_date,?) = ?) OR 
      (? BETWEEN to_char(start_date,?) AND to_char(end_date,?))","#{@tag}","#{@city}",'MM',"#{@date}",'MM',"#{@date}","#{@date}",'MM','MM']).order(@pending).order('start_date ASC').paginate(:page => params[:page])
    end
  else
    if @search != nil
      @events = Event.where(['(name LIKE ? OR description LIKE ? OR id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name LIKE ?))) AND (status = ?)',"%#{@search}%","%#{@search}%", "%#{@search}%","Approved"]).order('start_date ASC').paginate(:page => params[:page])
    else
      #for sqlite, use @events = Event.where(["(id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?)) OR city = ? OR strftime(?,start_date) = ?) AND (status = ?)","#{@tag}","#{@city}",'%Y-%m-%d',"#{@date}","Approved"]).order('start_date ASC').paginate(:page => params[:page])
      #@events = Event.where(["(id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?)) OR city = ? OR to_char(start_date,?) = ?) AND (status = ?)","#{@tag}","#{@city}",'YYYY-MM-DD',"#{@date}","Approved"]).order('start_date ASC').paginate(:page => params[:page])
      
      #for sqlite, use @events = Event.where(["(id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?)) OR city = ?) OR (? BETWEEN strftime(?,start_date) AND strftime(?,end_date)) OR (strftime(?,start_date) = ?) OR (strftime(?,end_date) = ?) AND (status = ?)","#{@tag}","#{@city}","#{@date}",'%m','%m','%m',"#{@date}",'%m',"#{@date}","Approved"]).order('start_date ASC').paginate(:page => params[:page])
      @events = Event.where(["(id IN (SELECT event_id FROM event_tags where tag_id IN (SELECT id FROM tags WHERE name = ?))) OR city = ? OR (? BETWEEN to_char(start_date,?) AND to_char(start_date,?)) AND (status = ?)","#{@tag}","#{@city}","#{@date}",'MM','MM',"Approved"]).order('start_date ASC').paginate(:page => params[:page])
    end

  end
  render :template => "events/search"
end

  def approve
    @event = Event.find(params[:id])
    @event.approve!
    redirect_to event_path(@event)
  end

  def reject
    @event = Event.find(params[:id])
    @event.reject!
    redirect_to event_path(@event)
  end

  def authenticate_owner
    if current_user.try(:id) != @event.user_id
      redirect_to event_path(@event)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def for_index
      if current_user.try(:admin?)
        @pending = Event.send(:sanitize_sql_array,['case when status = ? then 0 else 1 end',"Pending"])
        @events = Event.all.order(@pending).order('start_date ASC').paginate(:page => params[:page])
      else
        @events = Event.where(status: "Approved").order('start_date ASC').paginate(:page => params[:page])
        @header = "New Event"
        @submit = "Create Event"
      end
    end

    def for_show
      if !current_user.try(:admin?)
        if current_user.try(:id) != @event.user_id
          if @event.status != "Approved"
            redirect_to events_path
          end
        end
      end
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
      @picture = @event.pictures.first
      @header = "Edit Event"
      @submit = "Update Event"
    end

    def event_params
      #params.require(:event).permit(:name, :start_date, :end_date, :address, :website, :lat, :lon, :user_id)
      params.require(:event).permit!
    end
end
