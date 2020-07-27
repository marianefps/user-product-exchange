class ReportsController < ApplicationController
  def percentage_users_on_vacation
    total = User.count
    on_vacation = User.where(on_vacation: true).count

    json_response percentage_users_on_vacation: calculate_percentage(on_vacation, total)
  end

  def percentage_users_working
    total = User.count
    active = User.where(on_vacation: false).count

    json_response percentage_users_working: calculate_percentage(active, total)
  end

  def avg_users_equipment
    equipments = Inventory.group(:product).average(:quantity).map {|p, avg| [p, avg.to_i] }.to_h
    json_response avg_users_equipment: equipments
  end


  def total_price_equipments_on_vacation
    equipments = Inventory.joins(:user).merge(User.where(on_vacation: true)).group(:product).sum(:quantity)
    total_price = equipments.map do |product, quantity|
      Inventory::PRODUCTS[product] * quantity
    end.sum
    json_response total_price_equipments_on_vacation: total_price
  end

  private

  def calculate_percentage(x, total)
    return 0 if total.zero?

    (x * 100)/total
  end

end
