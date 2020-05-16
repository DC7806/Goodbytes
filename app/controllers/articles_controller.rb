class ArticlesController < ApplicationController
  before_action :find_channel
  before_action :find_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = @channel.articles.order(created_at: :desc)
  end

  def new
    @article = @channel.articles.new
  end

  def create
    @article = @channel.articles.new(article_params)
    
    if @article.save
      redirect_to channel_article_path(channel_id: @article.channel_id, id: @article.id), notice: "The article has been created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to channel_article_path(channel_id: @article.channel_id, id: @article.id), notice: "This article has been update."

    else
      render :edit
    end
  end

  def destroy
    @article.destroy  
    redirect_to @channel, notice: "This article has been deleted."
  end

  private
  def article_params
    params.require(:article).permit(:subject)
  end

  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def find_article
    @article = @channel.articles.find(params[:id])
  end
end
