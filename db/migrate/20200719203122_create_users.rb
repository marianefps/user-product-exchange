class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.date :birth_date
      t.string :country

      t.timestamps
    end
  end
end
