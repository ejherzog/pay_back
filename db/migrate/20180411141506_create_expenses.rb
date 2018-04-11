class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.date :date
      t.float :total
      t.string :description
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.string :category

      t.timestamps
    end
  end
end
