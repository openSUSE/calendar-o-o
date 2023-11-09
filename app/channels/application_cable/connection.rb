module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        user_id = cookies.encrypted&.[]('_calendar_oo_session')&.[]('warden.user.user.key')&.[](0)
        if verified_user = User.find_by(id: user_id)
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
