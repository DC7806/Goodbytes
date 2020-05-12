class TestController < ApplicationController
  def feature1
    # 邀請信內容測試
    # 寄送邀請信
    # 等待審核的邀請(收件箱)
    # 邀請名單(送出待同意的邀請)
    # 你的組織與成員名單(含踢人功能)
    render :feature1#, layout:false
  end
  def feature2
  end
end
