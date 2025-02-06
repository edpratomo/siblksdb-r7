class AddGroupRefToUsers < ActiveRecord::Migration[7.2]
  def up
    add_reference :users, :group, null: false, foreign_key: true, default: 1
    change_column_default :users, :group_id, from: 1, to: nil

  end

  def down
    remove_reference :users, :group
  end
end
