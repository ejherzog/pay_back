class CreateUserExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :user_expenses do |t|
      t.references :user, foreign_key: true
      t.references :expense, foreign_key: true
      t.boolean :paid

      t.timestamps
    end
  end
end
