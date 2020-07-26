class AddOnVacationToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :on_vacation, :boolean, default: false
  end
end
