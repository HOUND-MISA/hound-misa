class EventAttendeesController < ApplicationController
  before_filter :restrict_admin

  def join
    @event = Event.find(params[:id])
    if (@event.status != "Approved") || (!user_signed_in?) || (current_user.try(:id) == @event.user_id)
      redirect_to event_path(@event)
    else
      @event_attendee = EventAttendee.new
      @event_attendee.event = @event
      @event_attendee.user = current_user
      if @event_attendee.save
        @event.update(attendee_count: @event.attendee_count + 1)
        redirect_to event_path(@event)
      else
        redirect_to event_path(@event)
      end
    end
  end

  def leave
    @event = Event.find(params[:id])
    if (@event.status != "Approved") || (!user_signed_in?) || (current_user.try(:id) == @event.user_id)
      redirect_to event_path(@event)
    else
      @event_attendee = EventAttendee.where(['event_id = ? and user_id = ?',params[:id],current_user.try(:id)]).first
      @event_attendee.destroy!
      @event.update(attendee_count: @event.attendee_count - 1)
      redirect_to event_path(@event)
    end
  end

end


