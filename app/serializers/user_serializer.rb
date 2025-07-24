class UserSerializer < Blueprinter::Base
  identifier :id

  fields :first_name, :email
  field :last_name, exclude_if_nil: true
end
