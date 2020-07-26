class UsersController < ApplicationController

  def show
    user = User.find params[:id]
    json_response user.to_json(include: { inventories: { only: %i[product quantity] } })
  end

  def create
    user = User.create! create_params

    json_response user.to_json(include: { inventories: { only: %i[product quantity] } }),
                  status: :created
  end

  def update
    user = User.find params[:id]
    user.update update_params
    head :no_content
  end

  def exchange
    requester = User.find params[:id]
    exchange = ProductExchangeService.new requester, exchange_params
    if exchange.save
      head :ok
    else
      json_response({ message: exchange.errors }, status: :unprocessable_entity)
    end
  end

  def on_vacation
    user = User.find params[:id]
    user.update! on_vacation: true
    head :no_content
  end

  def return_vacation
    user = User.find params[:id]
    user.update! on_vacation: false
    head :no_content
  end

  private

  def exchange_params
    params.require(:exchange).permit :receiver,
                                     { products_requester: %i[product quantity] },
                                     { products_receiver: %i[product quantity] }
  end

  def create_params
    params.require(:user).permit :name,
                                 :username,
                                 :birth_date,
                                 :email,
                                 :country,
                                 inventories_attributes: %i[product quantity]
  end

  def update_params
    params.require(:user).permit :country
  end
end
