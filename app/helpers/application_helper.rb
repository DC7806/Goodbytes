module ApplicationHelper
  def render_edit_form(content, *keys)
    form_pattern = {
      content: content,
      title: false,
      desc: false
    }
    keys.each do |key|
      form_pattern[key] = true
    end

    render "shared/edit_form/edit_form", **form_pattern
  end
end
