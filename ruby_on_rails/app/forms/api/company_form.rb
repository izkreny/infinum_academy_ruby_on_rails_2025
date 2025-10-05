module Api
  class CompanyForm
    include ActiveModel::Model

    attr_accessor :name

    validates :name, presence: true

    def save
      return false if invalid?

      Company.create(name: name)
    end
  end
end
