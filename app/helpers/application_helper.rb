module ApplicationHelper

  def render_edit_form(content, *keys)
    form_pattern = {
      content: content,
      title: false,
      desc: false,
      url: false
    }
    keys.each do |key|
      form_pattern[key] = true
    end
    render "shared/template/edit_form", **form_pattern
  end

  def render_drag_bar(content, display)
    render "shared/template/drag_bar",content: content, display: display
  end
  
end

