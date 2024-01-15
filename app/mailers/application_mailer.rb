# frozen_string_literal: true

# The base application mailer
class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.site.dig(:mail, :from)
  layout 'mailer'
end
