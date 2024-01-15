# frozen_string_literal: true

# Type of alarm delivered as a notification
class AlarmNotification < Alarm
  def action
    'DISPLAY'
  end
end
