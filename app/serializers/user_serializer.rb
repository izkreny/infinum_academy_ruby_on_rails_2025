class UserSerializer < Blueprinter::Base
  identifier :id

  fields :first_name, :email, :created_at, :updated_at
  field :last_name, exclude_if_nil: true
end
