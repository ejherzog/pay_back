class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :user, foreign_key: true
      t.references :expense, foreign_key: true
      t.boolean :paid

      t.timestamps
    end
  end
end
