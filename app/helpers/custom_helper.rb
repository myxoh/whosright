module CustomHelper

  def span(content, options={})
    content_tag(:span, content, options)
  end

  def badge(content, options = {})
    options[:class]=options[:class].to_s+" badge"
    span(content, options)
  end

  def list_errors(element)
    render partial: "partials/display_element_error", locals: {element: element}
  end

  def magic_url_for(element, url = nil)
    case element
      when Position
        url ||= if element.new_record?
                  discussion_positions_path(element.discussion)
                else
                  position_path(element)
                end
    end

    url
  end
end