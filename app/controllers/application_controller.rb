# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_timezone

  def set_team
    @team = Team.find_by(slug: params[:team_slug] || params[:slug])

    redirect_to teams_url, alert: 'Team not found' unless @team
  end

  def set_teams_user
    @teams_user = TeamsUser.find(params[:teams_user_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: team_url(@team), alert: 'Team membership not found'
  end

  def set_event
    @event = @team.events.find_by(slug: params[:event_slug] || params[:slug])

    redirect_to team_events_url, alert: 'Event not found' unless @event
  end

  def set_event_occurrence
    @event_occurrence = EventOccurrence.find(params[:event_occurrence_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: team_event_url(@team, @event), alert: 'Event occurrence not found'
  end

  def set_alarm
    @alarm = Alarm.find(params[:alarm_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: team_event_alarms_url(@team, @event), alert: 'Alarm not found'
  end

  def set_user
    @user = User.find_by(username: params[:user_username] || params[:username])

    redirect_to users_url, alert: 'User not found' unless @user
  end

  protected

  def set_timezone
    return unless (timezone = request.cookies["timezone"])

    Time.zone = ActiveSupport::TimeZone[timezone]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username name email password password_confirmation remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login username name email password remember_me])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[username name email password password_confirmation current_password])
  end
end
