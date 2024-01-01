# frozen_string_literal: true

# The primary helper in the applications
module ApplicationHelper
  def avatar(user, size: 24)
    image_tag "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=#{size * 2}&d=robohash",
              class: 'rounded', style: "width: #{size}px; height: #{size}px"
  end

  def range_display(from, to)
    date = local_time(from, :short)
    date += ' - '

    if from.to_date == to.to_date
      date += local_time(to, '%H:%M')
    else
      date += local_time(to, :short)
    end

    date
  end
end
