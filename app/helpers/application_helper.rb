module ApplicationHelper

  # 根據當前時間來打招呼
  def greet
    current_hour = Time.zone.now.hour
    return '早安' if current_hour.in?(5..12)
    return '午安' if current_hour.in?(13..18)
    '晚安'
  end

  def render_edit_form(content, *keys)
    # 寫一個helper method來統一管理template的欄位
    # 這樣碰到欄位要新增時我只需要來改這邊就好
    # 現有的一堆template都可以不被影響
    # 算是為了方便管理樣板而誕生的method
    form_options = {
      title: false,
      desc: false,
      url: false,
      image: false
    }
    keys.each do |key|
      form_options[key] = true
    end
    
    render "shared/template/edit_form",content: content, **form_options
  end

  def render_drag_bar(content, display)
    render "shared/template/drag_bar",content: content, display: display
  end

  def comment
    # 註解用空method
  end
  
end

