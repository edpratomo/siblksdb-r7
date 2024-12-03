class AdmissionFee < Fee

  def self.current
    where("active_since IS NOT NULL AND active_since <= ?", DateTime.now).order(:active_since).last
  end

end
