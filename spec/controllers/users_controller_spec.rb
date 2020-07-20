require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it 'valid create params' do
    valid_attributes = { user: attributes_for(:user, inventories_attributes: [attributes_for(:inventory, user: nil)] ) }

    should permit(:name, :username, :birth_date, :email, :country, inventories_attributes: [:product, :quantity])
      .for(:create, params: valid_attributes).on(:user)
  end

  it 'valid update params' do
    user = create :user
    valid_attributes = { id: user.id, user: {country: 'New Country'} }

    should permit(:country)
      .for(:update, params: valid_attributes).on(:user)
  end
end
