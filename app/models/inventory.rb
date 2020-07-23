class Inventory < ApplicationRecord
  PRODUCTS = {
    desktop_gamer: 252,
    notebook: 202,
    laser_printer: 126,
    smartphone: 50,
    mouse: 20
  }.with_indifferent_access.freeze

  belongs_to :user

  validates :product, inclusion: { in: PRODUCTS.keys.map(&:to_s),
                                   message: "%{value} is not valid. It's allowed only: #{PRODUCTS.keys.to_sentence}" },

                      uniqueness: { scope: :user_id }

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
