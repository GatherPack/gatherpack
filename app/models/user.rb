class User < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }, ignore: :encrypted_password
  has_one :person
  accepts_nested_attributes_for :person
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :developer, :google_oauth2, :discord, :github ]

  validate :password_change, on: :update

  after_create :adminify_first_user

  attr_accessor :old_password

  def self.create_from_provider_data(provider_data)
    if Settings[:oauth_signup]
      where(provider: provider_data.provider, uid: provider_data.uid).first_or_create  do |user|
        user.email = provider_data.info.email
        user.password = Devise.friendly_token[0, 20]
        user.person = Person.new
        user.person.first_name = provider_data.info.first_name
        user.person.last_name = provider_data.info.last_name
      end
    else
      find_by(email: provider_data.info.email).update(provider: provider_data.provider, uid: provider_data.uid)
    end
  end

  private

  def adminify_first_user
    if User.count == 1
      User.first.update(admin: true)
    end
  end

  def password_change
    if self.persisted? && self.password.present?
      if self.password != self.password_confirmation
        errors.add(:password_confirmation, "doesn't match the password.")
      end

      unless Devise::Encryptor.compare(User, encrypted_password_was, old_password)
        errors.add(:old_password, "must be the same as the old password.")
      end
    end
  end

  def password_required?
    false
  end
end
