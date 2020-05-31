class SubscribersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_subscriber, only: [:destroy]

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

  end

  private    
    def find_subscriber
      @subscriber = @channel.subscribers.find_by(email: params[:email])
    end

    def subscriber_params
      params.require(:subscriber).permit(
        :email,
        :channel_id
      )
    end

end
