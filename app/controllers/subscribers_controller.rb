class SubscribersController < ApplicationController
  skip_before_action :authenticate_user!

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
    subscriber = channel.subscribers.find_by(email: params[:email])
    if subscriber and subscriber.destroy
      render js: 'alert("成功取消訂閱！")'
    end

  end

  private
    def subscriber_params
      params.require(:subscriber).permit(
        :email,
        :channel_id
      )
    end

end
