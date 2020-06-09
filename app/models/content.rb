class Content < ApplicationRecord
  acts_as_paranoid
  belongs_to :article
  has_one :channel, through: :article

  # 這個enum很神奇，可以讓你明明是存的純數字的欄位變成一種類似狀態機
  # https://blog.niclin.tw/2017/07/30/%E4%BD%BF%E7%94%A8-avtiverecordenum-%E5%BB%BA%E7%AB%8B%E6%98%93%E8%AE%80%E7%9A%84%E7%8B%80%E6%85%8B%E5%B1%AC%E6%80%A7/
  # 我在很多地方有直接把layout填進路徑裡做render存取
  # 這邊看不懂那些應該就都不懂
  enum layout: {
    one_title_one_desc: 0,
    one_title: 1,
    one_desc: 2,
    saved_link: 3,
    one_title_one_image: 4,
    left_image_right_text: 5,
    left_text_right_image: 6
  }
  
  LINE_LIMIT = 90

  def self.display_layout
    {
      0 => "標題/內文",
      1 => "標題",
      2 => "內文",
      3 => "超連結",
      4 => "標題/圖片",
      5 => "左圖右文",
      6 => "左文右圖"
    }
  end

  def display_title
    display_on_page(title, "段落標題").line_break(LINE_LIMIT)
  end
  
  def display_desc
    display_on_page(desc, "段落內文，在此處多撰寫一些具有您風格的文章，以使您的文章內容更加豐富～！").line_break(LINE_LIMIT)
  end

  private
    def display_on_page(origin_text, default_text)
      origin_text.present? ? origin_text : default_text
    end

  # 擺上面會出錯，擺下面就正常，不懂為什麼
  mount_uploader :image, ImageUploader
end