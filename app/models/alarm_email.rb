# frozen_string_literal: true

# Type of alarm that's delivered over email
class AlarmEmail < Alarm
  validates :email, presence: true

  def action
    'EMAIL'
  end
end
