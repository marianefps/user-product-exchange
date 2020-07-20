require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:product).scoped_to(:user_id) }
    xit 'product inclusion of' do
      should validate_inclusion_of(:product).
        in_array(Inventory::PRODUCTS.keys.map(&:to_s))
    end

    it { should validate_presence_of(:quantity) }
    it do
      should validate_numericality_of(:quantity)
        .is_greater_than(0)
    end
  end

  it { should belong_to(:user) }
end
