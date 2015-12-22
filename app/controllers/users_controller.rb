class UsersController < ApplicationController
  before_filter :authenticate_owner, only: [:edit]

  def index
    @users = User.where(['email != ?', "admin@hound.ph"])
  end

  def show
    @user = User.find(params[:id])
    @attended_events = Event.where(['id IN (SELECT event_id FROM event_attendees WHERE user_id = ?)',params[:id]]).order('start_date ASC').limit(7)
    @pending_events = @user.events.where(status: "Pending").order('start_date ASC').limit(7)
    @organized_events = @user.events.where(status: "Approved").order('start_date ASC').limit(7)
    @favorites = Tag.where(['id IN 
      (
        SELECT i.id FROM 
        (
          SELECT g.id AS id, COUNT(*) AS counter FROM events d
          INNER JOIN
          (
            SELECT h.id FROM events h
            WHERE (h.user_id = ? AND status = ?)
            UNION
            SELECT a.id FROM users c
            LEFT JOIN event_attendees b on b.user_id = c.id
            LEFT JOIN events a ON a.id = b.event_id
            WHERE c.id = ?
          ) AS e ON d.id = e.id
          LEFT JOIN event_tags f ON f.event_id = d.id
          LEFT JOIN tags g ON g.id = f.tag_id
          GROUP BY g.id ORDER BY counter DESC LIMIT 4
        ) AS i
      )',@user.id, "Approved", @user.id])
    render :template => 'users/show'
  end

  def events
    @user = User.find(params[:id])
    if params[:organized]
      @events = @user.events.where(status: "Approved").order('start_date ASC').paginate(:page => params[:page])
      render template: "users/events"
    elsif params[:attended]
      @events = Event.where(['id IN (SELECT event_id FROM event_attendees WHERE user_id = ?)',params[:id]]).order('start_date ASC').paginate(:page => params[:page])
      render template: "users/events"
    elsif params[:pending]
      if (current_user.try(:admin?)) || (current_user.try(:id) == @user.id)
         @events = @user.events.where(status: "Pending").order('start_date ASC').paginate(:page => params[:page])
         render template: "users/events"
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def edit
    @user = User.find(params[:id])
    render :template => 'devise/registrations/edit'
  end

  def update
  end

  def destroy
    @user = User.find(params[:id])
    if (current_user.try(:admin?)) || (current_user.try(:id) == @user.id)
      @attended_events = Event.where(['id IN (SELECT event_id FROM event_attendees WHERE user_id = ?)',params[:id]])
      @attended_events.each do |attended_event|
        attended_event.update(attendee_count: attended_event.attendee_count - 1)
      end
      @user.destroy!
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def authenticate_owner
    @user = User.find(params[:id])
    if current_user.try(:id) != @user.id
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit!
  end

end