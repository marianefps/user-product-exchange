class User < ApplicationRecord

  has_many :inventories, dependent: :delete_all
  accepts_nested_attributes_for :inventories

  validates :name, :country, :birth_date, presence: true
  validates :username, :email, presence: true, uniqueness: true

end
