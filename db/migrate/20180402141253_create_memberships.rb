class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.references :group_id, foreign_key: true
      t.references :user_id, foreign_key: true

      t.timestamps
    end
  end
end
