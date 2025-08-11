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
class UserSerializer < Blueprinter::Base
  identifier :id

  fields :first_name, :email, :created_at, :updated_at
  field :last_name, exclude_if_nil: true
  field :password do |user| # rubocop:disable Style/SymbolProc
    user.password_digest
  end
end
