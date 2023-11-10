# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.site.dig(:mail, :from)
  layout 'mailer'
end
