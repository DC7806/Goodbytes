module ApplicationHelper
  
  def form_pattern(content,keys)
    form_pattern = {
      content: content,
      title: false,
      desc: false,
      url: false
    }
    keys.each do |key|
      form_pattern[key] = true
    end
    form_pattern
  end

  def render_edit_form(content, *keys)
    pattern = form_pattern(content, keys)
    render "shared/template/edit_form", **pattern
  end

  def render_drag_bar(content, display, *keys)
    pattern = form_pattern(content, keys)
    pattern[:display] = display
    render "shared/template/drag_bar", **pattern
  end
  
end

