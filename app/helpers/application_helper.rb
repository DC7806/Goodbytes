module ApplicationHelper
  def render_form(path, *keys, content: nil)
    form_pattern = {
      content: content,
      title: false,
      desc: false
    }
    keys.each do |key|
      form_pattern[key] = true
    end

    render path, **form_pattern
  end
end
