# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  functional_index_users_on_email  (lower((email)::text)) UNIQUE
#  index_users_on_email             (email) UNIQUE
#
class User < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings

  EMAIL_REGEXP = /[\w._%+-]+@[\w.-]+\.\w{2,}/ # URI::MailTo::EMAIL_REGEXP
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEXP
end
