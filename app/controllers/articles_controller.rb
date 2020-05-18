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
      redirect_to organization_channel_article_path(@article, **path_params), notice: "The article has been created."
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
      redirect_to organization_channel_article_path(@article, **path_params), notice: "This article has been update."

    else
      render :edit
    end
  end

  def destroy
    @article.destroy  
    redirect_to organization_channel_path(@channel, **path_params), notice: "This article has been deleted."
  end

  private
  def article_params
    params.require(:article).permit(:subject)
  end

  def find_article
    @article = @channel.articles.find(params[:id])
  end
end
