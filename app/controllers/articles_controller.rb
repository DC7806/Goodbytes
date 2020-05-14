class ArticlesController < ApplicationController
  before_action :find_mail, only: [:edit, :show]

  def index
    @channel = Channel.find(params[:channel_id])
    @articles = @channel.articles.order_by(created_at: :desc)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(mail_params)
    @mail.channel_id = params[:channel_id]

    if @article.save
      redirect_to @article, notice: "The mail has been created."
    else
      render :new
    end
  end

  def show
  end

  private
  def mail_params
    params.require(:mail).permit(:subject)
  end

  def find_mail
  rescue
    redirect_to article_path, notice: "Sorry we cannot find this email."
  end
end
