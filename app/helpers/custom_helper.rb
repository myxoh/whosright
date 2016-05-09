module CustomHelper
  def span(content, options={})
    content_tag(:span, content, options)
  end
  def badge(content, options = {})
    options[:class]=options[:class].to_s+" badge"
    span(content, options)
  end
end