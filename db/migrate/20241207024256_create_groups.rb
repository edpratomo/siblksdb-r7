class CreateGroups < ActiveRecord::Migration[7.2]
  def up
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end

    %w[sysadmin admin staff instructor student].each do |group_name|
      Group.create(name: group_name)
    end
  end

  def down
    drop_table :groups
  end
end
