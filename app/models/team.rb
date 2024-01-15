# frozen_string_literal: true

# Team object
class Team < ApplicationRecord
  self.implicit_order_column = :slug

  has_many :teams_users, dependent: :destroy
  has_many :users, through: :teams_users
  has_many :events, dependent: :destroy
  has_many :alarms, as: :alarmable, dependent: :destroy

  enum :color, %w[pink red orange yellow green blue indigo purple]

  validates :slug,
            format: { with: /\A[a-z0-9_-]+\z/, message: I18n.t('format_validation.alphanumeric_with_dashes') }

  COLOR = { pink: '#e83ed4',
            red: '#e01b24',
            orange: '#ff7800',
            yellow: '#f6d32d',
            green: '#33d17a',
            blue: '#3584e4',
            indigo: '#664ee4',
            purple: '#9141ac' }.freeze

  ICALENDAR_DETAILS = {
    description: ->(team) { team.name },
    color: ->(team) { Team::COLOR[team.color.to_sym] },
    url: ->(team) { Rails.application.routes.url_helpers.team_url(team) },
    source: ->(team) { Rails.application.routes.url_helpers.team_url(team, format: :ics) }
  }.freeze

  def to_param
    slug
  end

  def icalendar
    Icalendar::Calendar.new.tap do |ical|
      ICALENDAR_DETAILS.each do |prop, value|
        ical.send("#{prop}=", value.call(self))
      end
      ical_timezone.each { |timezone| ical.add_timezone(timezone) }
      events.each { |event| ical.add_event(event.ievent) }
    end
  end

  def owner
    teams_users.find_by(role: 'owner')&.user
  end

  def admins
    User.where(id: teams_users.where(role: 'admin')&.pluck(:user_id))
  end

  private

  def ical_timezone
    events.select(:timezone).distinct.pluck(:timezone).map do |timezone|
      ActiveSupport::TimeZone.find_tzinfo(timezone).ical_timezone(Time.zone.now)
    end
  end
end
