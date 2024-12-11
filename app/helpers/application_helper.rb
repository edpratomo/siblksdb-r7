module ApplicationHelper
  def humanize_class(class_name)
    class_name.to_s.underscore.humanize.titleize
  end
end
