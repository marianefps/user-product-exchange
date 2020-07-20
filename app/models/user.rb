class User < ApplicationRecord

  validates :name, :country, :birth_date, presence: true
  validates :username, :email, presence: true, uniqueness: true

end
