# frozen_string_literal: true

class Team < ApplicationRecord
  self.implicit_order_column = :slug

  has_many :teams_users
  has_many :users, through: :teams_users
  has_many :events
  has_many :alarms, as: :alarmable

  enum :color, %w[pink red orange yellow green blue indigo purple]

  validates :slug, format: { with: /\A[a-z0-9_]+\z/, message: 'Has to be alphanumeric with underscores'}
           
  COLOR = { pink: '#e83ed4',
            red: '#e01b24',
            orange: '#ff7800',
            yellow: '#f6d32d',
            green: '#33d17a',
            blue: '#3584e4',
            indigo: '#664ee4',
            purple: '#9141ac' }.freeze

  def to_param
    slug
  end

  def icalendar
    cal = Icalendar::Calendar.new
    cal.description = name
    cal.color = COLOR[color.to_sym]
    cal.url = Rails.application.routes.url_helpers.team_url(self)
    cal.source = Rails.application.routes.url_helpers.team_url(self, format: :ics)

    events.select(:timezone).distinct.pluck(:timezone).each do |timezone|
      cal.add_timezone ActiveSupport::TimeZone.find_tzinfo(timezone).ical_timezone Time.now
    end

    events.each do |event|
      cal.add_event(event.ievent)
    end

    cal
  end

  def owner
    teams_users.find_by(role: 'owner')&.user
  end

  def admins
    User.where(id: Team.first.teams_users.where(role: 'admin')&.pluck(:user_id))
  end
end
