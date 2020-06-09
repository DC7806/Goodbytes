class Subscriber < ApplicationRecord
  belongs_to :channel
  validates :email, format: { 
    with: /\A[a-z0-9]+((_|\.)[a-z0-9]+)*@[a-z0-9]+(\.[a-z]+){1,3}\z/ 
  }
  # 詳請參考user model

end
