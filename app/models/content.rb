class Content < ApplicationRecord
  acts_as_paranoid
  belongs_to :article
  has_one :channel, through: :article
  enum layout: {
    one_title_one_desc: 0,
    one_title: 1,
    one_desc: 2,
    saved_link: 3,
    one_title_one_image: 4
  }
  

  LINE_LIMIT = 30

  def display_on_page(origin_text, show_if_no_text)
    origin_text.present? ? origin_text : show_if_no_text
  end

  def display_title
    display_on_page(title, "Title").line_break(LINE_LIMIT)
  end

  def display_desc
    display_on_page(desc, "Text").line_break(LINE_LIMIT)
  end

  mount_uploader :image, ImageUploader
end