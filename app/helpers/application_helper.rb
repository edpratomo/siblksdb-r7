module ApplicationHelper
  def humanize_class(class_name)
    class_name.to_s.underscore.humanize.titleize
  end

  # helpers for sidebar
  def active_tab_class(*paths)  
    active = false  
    paths.each { |path| active ||= current_page?(path) }  
    active ? 'active' : ''  
  end  

  def active_arrow_class(*paths)  
    active = false  
    paths.each { |path| active ||= current_page?(path) }  
    active ? 'fa-angle-down' : 'fa-angle-left'  
  end  

  def expand_treeview(*paths)
    active = false  
    paths.each { |path| active ||= current_page?(path) }  
    active ? raw('style="display: block;"') : ''  
  end
end
