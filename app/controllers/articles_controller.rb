class ArticlesController < ApplicationController
  before_action :find_channel, only: [:index, :new, :edit, :show]
  before_action :find_article, only: [:create]

  def index
    @articles = @channel.articles.order(created_at: :desc)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to channel_articles_path(params[:channel_id]), notice: "The mail has been created."
    else
      render :new
    end
  end

  def show
  end

  private
  def article_params
    params.require(:article).permit(:subject)
  end

  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def find_article
    @article.channel_id = params[:channel_id]
  rescue
    redirect_to article_path, notice: "Sorry we cannot find this email."
  end
end
