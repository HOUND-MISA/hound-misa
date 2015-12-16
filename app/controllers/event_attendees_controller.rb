class EventAttendeesController < ApplicationController

  def join
    @event_attendee = EventAttendee.new
    @event_attendee.event = Event.find(params[:id])
    @event_attendee.user = current_user
    if @event_attendee.save
      @event_attendee.event.update(attendee_count: @event_attendee.event.attendee_count + 1)
      redirect_to event_path(params[:id])
    else
      redirect_to event_path(params[:id])
    end
  end

  def leave
    @event_attendee = EventAttendee.where(['event_id = ? and user_id = ?',params[:id],current_user.id]).first
    @event_attendee.destroy!
    @event = Event.find(params[:id])
    @event_attendee.event.update(attendee_count: @event_attendee.event.attendee_count - 1)
    redirect_to event_path(params[:id])
  end

end


