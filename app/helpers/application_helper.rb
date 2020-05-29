module ApplicationHelper

  def render_edit_form(content, *keys)
    # 寫一個helper method來統一管理template的欄位
    # 這樣碰到欄位要新增時我只需要來改這邊就好
    # 現有的一堆template都可以不被影響
    # 算是為了方便管理樣板而誕生的method
    form_pattern = {
      content: content,
      title: false,
      desc: false,
      url: false,
      image: false
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

