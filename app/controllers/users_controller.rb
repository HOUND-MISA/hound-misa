class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :authenticate_owner, except: [:index, :show]

  def index
  end

  def show
    @user = User.find(params[:id])
    @attended_events = Event.where(['id IN (SELECT event_id FROM event_attendees WHERE user_id = ?)',params[:id]])
    render :template => 'users/show'
  end

  def edit
    @user = User.find(params[:id])
    render :template => 'devise/registrations/edit'
  end

  def update
  end

  def destroy
    @user = User.find(params[:id])
    @attended_events = Event.where(['id IN (SELECT event_id FROM event_attendees WHERE user_id = ?)',params[:id]])
    @attended_events.each do |attended_event|
      attended_event.update(attendee_count: attended_event.attendee_count - 1)
    end
    @user.destroy!
    redirect_to root_path
  end

  def authenticate_owner
    @user = User.find(params[:id])
    if current_user.id != @user.id
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit!
  end

end