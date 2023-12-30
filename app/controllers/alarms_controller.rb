# frozen_string_literal: true

class AlarmsController < ApplicationController
  before_action :set_team
  before_action :set_event
  before_action :set_alarm, only: %i[edit update destroy]

  def index
    @alarms = policy_scope(Alarm).where(event: @event)
  end

  def new
    @alarm = authorize @event.alarms.new, policy_class: AlarmPolicy
  end

  def create
    @alarm = authorize @event.alarms.new(alarm_params), policy_class: AlarmPolicy

    if @alarm.save
      redirect_to team_event_alarms_url(@team, @event, @alarm), notice: 'Alarm has been created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @alarm, policy_class: AlarmPolicy
  end

  def update
    authorize @alarm, policy_class: AlarmPolicy

    if @alarm.update(alarm_params)
      redirect_to team_event_alarms_url(@team, @event, @alarm), notice: 'Alarm has been updated!'
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @alarm, policy_class: AlarmPolicy

    @alarm.destroy
    redirect_to team_event_alarms_url(@team, @event), notice: 'Alarm removed'
  end

  private

  def alarm_params
    type = [:alarm, :alarm_email, :alarm_notification].map { |t| params.key?(t) ? t : nil }.compact.first
    params.require(type).permit(:type, :email, :interval, :period, :description, :alarmable_type, :alarmable_id)
  end
end
