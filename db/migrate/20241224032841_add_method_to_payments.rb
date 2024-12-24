class AddMethodToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :method, :string, null: false, default: "cash"
  end
end
