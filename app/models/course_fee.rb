class CourseFee < Fee
  belongs_to :course

  def self.current course
    where("course_id = ? AND active_since IS NOT NULL AND active_since <= ?", course.id, DateTime.now).order(:active_since).last
  end
end
