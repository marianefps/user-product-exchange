class UsersController < ApplicationController

  def create
    @user = User.create! create_params

    json_response @user.to_json(include: { inventories: { only: %i[product quantity] } }),
                  status: :created
  end

  def update
    @user = User.find params[:id]
    @user.update update_params
    head :no_content
  end

  private

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
