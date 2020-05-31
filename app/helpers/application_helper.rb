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
  
end
