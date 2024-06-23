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

    date += if from.to_date == to.to_date
              local_time(to, '%H:%M %Z')
            else
              local_time(to, '%d %b %H:%M %Z')
            end

    date
  end

  def markdownify(text)
    Kramdown::Document.new(text, input: 'GFM').to_html.html_safe
  end
end
