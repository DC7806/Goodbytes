class ArticleMailerJob < ApplicationJob
  queue_as :default

  def perform(email, article_id)
    ArticleMailer.send_article(email, article_id).deliver
  end
end
