class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.float :total
      t.text :description
      t.date :date
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.string :category

      t.timestamps
    end
  end
end
