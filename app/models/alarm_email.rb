class AlarmEmail < Alarm
  validates_presence_of :email

  def action
    'EMAIL'
  end
end
