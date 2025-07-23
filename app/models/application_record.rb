class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  skip_before_action :verify_authenticity_token
end
