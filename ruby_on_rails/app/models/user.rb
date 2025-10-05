# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string
#  password_digest :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  functional_index_users_on_email  (lower((email)::text)) UNIQUE
#  index_users_on_email             (email) UNIQUE
#  index_users_on_token             (token) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_secure_token
  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings

  EMAIL_REGEXP = /[\w._%+-]+@[\w.-]+\.\w{2,}/ # URI::MailTo::EMAIL_REGEXP
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEXP

  ROLES = {
    'admin' => 'administrator',
    'user' => 'customer',
    nil => 'public'
  }
  validates :role, inclusion: ROLES.map { |db_name, _public_name| db_name }

  ROLES.each do |role, method_name|
    define_method "#{method_name}?" do
      self.role == role
    end
  end
end
