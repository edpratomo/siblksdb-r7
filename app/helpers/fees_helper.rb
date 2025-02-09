module FeesHelper
  def admission_fee_missing
    AdmissionFee.current.nil? ? "text-danger" : ''
  end

  def book_uniform_fee_missing
    if BookUniformFee.joins(:program).group(:program).count('programs.id').count < Program.all.size
      "text-danger"
    else
      ''
    end
  end

  def reg_course_fee_missing
    course_fee_missing(RegCourseFee)
  end

  def int_course_fee_missing
    course_fee_missing(IntCourseFee)
  end

  def ext_course_fee_missing
    course_fee_missing(ExtCourseFee)
  end

  private

  def course_fee_missing(fee_class)
    if fee_class.joins(:course).group(:course).count('courses.id').count < Course.all.size
      "text-danger"
    else
      ''
    end
  end

end
