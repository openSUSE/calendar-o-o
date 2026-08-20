# frozen_string_literal: true

namespace :devel do
  task guard: :environment do
    abort('This task is only intended for use in the development environment.') unless Rails.env.development?
  end

  desc 'Populate database with a dummy user and team'
  task populate: [:guard] do
    user_name = 'admin'
    user_email = "#{user_name}@example.com"
    user_password = 'wowzers'

    team_name = 'developers'
    team_slug = 'devs'

    # purposefully re-creating instead of find_or_create here
    User.find_by(username: user_name)&.destroy
    Team.find_by(slug: team_slug)&.destroy

    u = User.create!(email: user_email, password: user_password, name: user_name, username: user_name)
    t = Team.create!(name: team_name, slug: team_slug)
    TeamsUser.create!(team: t, user: u, role: :owner)
  end

  desc 'Initialize database for development'
  task setup: [:guard, 'db:create', 'db:migrate', :populate]
end
