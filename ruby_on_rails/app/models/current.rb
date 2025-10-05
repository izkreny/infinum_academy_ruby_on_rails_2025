class Current < ActiveSupport::CurrentAttributes
  attribute :user

  def initialize
    super
    @user = User.new
  end
end
