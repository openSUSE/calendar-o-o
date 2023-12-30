# frozen_string_literal: true

class User < ApplicationRecord
  self.implicit_order_column = :username

  has_many :teams_users
  has_many :teams, through: :teams_users
  has_many :roles
  has_many :alarms, as: :alarmable
  accepts_nested_attributes_for :roles,
                                allow_destroy: true

  def to_param
    username
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  device_authenticatables = [:omniauthable]
  if Rails.configuration.site.dig(
    :authentication, :local
  )
    device_authenticatables += %i[database_authenticatable registerable
                                  recoverable rememberable validatable]
  end
  devise(*device_authenticatables)

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.username = auth.info.nickname
    end
  end

  def admin?
    roles.exists?(name: 'admin')
  end
end
