module ApplicationHelper

  # 根據當前時間來打招呼
  def greet
    now = Time.now
    today = Date.today.to_time
  
    morning = today.beginning_of_day
    noon = today.noon
    evening = today.change( hour: 17 )
    night = today.change( hour: 20 )
    tomorrow = today.tomorrow
  
    if (morning..noon).cover? now
      'Good morning'
    elsif (noon..evening).cover? now
      'Good afternoon'
    elsif (evening..night).cover? now
      'Good evening'
    elsif (night..tomorrow).cover? now
      'Good night'
    end
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
  
end

