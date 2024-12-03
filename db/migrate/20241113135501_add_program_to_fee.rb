class AddProgramToFee < ActiveRecord::Migration[6.1]
  def change
    execute <<SQL
ALTER TABLE fees ADD COLUMN program_id INTEGER;
SQL
  end
end
