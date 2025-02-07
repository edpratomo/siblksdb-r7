# from https://www.jorgemanrubia.com/2019/02/16/form-validations-with-html5-and-modern-rails/
custom_field_error_1 = Proc.new do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')

  model = instance_tag.object
  error_message = model.errors.full_messages.join(', ')

  html = if field
           field['class'] = "#{field['class']} invalid"
           html = <<-HTML
              #{fragment.to_s}
              <p class="error">#{error_message}</p>
           HTML
           html
         else
           html_tag
         end

  html.html_safe
end

# from siblksdb-v1
custom_field_error_2 = Proc.new do |html_tag, instance|
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe
  # add nokogiri gem to Gemfile
  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, input"
  elements.each do |e|
    if e.node_name.eql? 'label'
      # html = %(<div class="clearfix error">#{e}</div>).html_safe
      html = "#{e}".html_safe
    elsif e.node_name.eql? 'input'
      if instance.error_message.kind_of?(Array)
        html = %(<div class="field_with_errors">#{html_tag}<span class="help-inline">&nbsp;#{instance.error_message.join(',')}</span></div>).html_safe
      else
        html = %(<div class="field_with_errors">#{html_tag}<span class="help-inline">&nbsp;#{instance.error_message}</span></div>).html_safe
      end
    end
  end
  html
end

ActionView::Base.field_error_proc = custom_field_error_2
