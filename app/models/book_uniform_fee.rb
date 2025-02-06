class BookUniformFee < Fee
  belongs_to :program

  def self.current program
    where("program_id = ? AND active_since IS NOT NULL AND active_since <= ?", program.id, DateTime.now).order(:active_since).last
  end
end
