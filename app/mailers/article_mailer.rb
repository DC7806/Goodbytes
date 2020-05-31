class ArticleMailer < ApplicationMailer
  default from: 'subscribe@mailby.goodbyt.es'
  def send_article(email, article_id)
    @email = email
    @article = Article.find(article_id)
    @channel = @article.channel
    @contents = @article.contents
    mail to: @email, subject: "#{@channel.name}: #{@article.subject}"
  end
end
