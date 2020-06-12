class SubscribersController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_session_empty
  def create
    # 傳入參數預期應該會有
    #   channel id: 頻道id
    #   email: 訂閱者email
    @subscriber = Subscriber.new(subscriber_params)
    if @subscriber.save
      render js: 'alert("訂閱成功！")'
    else
      render js: 'alert("輸入錯誤")'
    end
  end

  def destroy
    # 傳入參數預期應該會有
    #   channel id: 頻道id
    #   email: 訂閱者email
    channel = Channel.find(params[:channel_id])
    email = params[:email]
    subscriber = channel.subscribers.find_by(email: email)
    if subscriber and subscriber.destroy
      @notice = "#{email}\n成功取消訂閱！"
    else
      @notice = "#{email}\n退訂失敗！"
    end
    redirect_to landing_channel_path(channel), notice: @notice

  end

  private
    def subscriber_params
      params.require(:subscriber).permit(
        :email,
        :channel_id
      )
    end

end
