class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy]
  before_action :find_channel
  before_action :channel_member?

  def index
    @articles = @channel.articles.order(created_at: :desc)
  end

  def new
    @article = @channel.articles.new
  end

  def create
    @article = @channel.articles.new(article_params)
    
    if @article.save
      redirect_to article_path(@article), notice: "The article has been created."
    else
      render :new
    end
  end

  def show
  end

  def edit
    render layout: "content"
  end

  def update
    render layout: "content"
    if @article.update(article_params)
      redirect_to article_path(@article), notice: "This article has been update."

    else
      render :edit
    end
  end

  def destroy
    @article.destroy  
    redirect_to channel_path, notice: "This article has been deleted."
  end

  private
  def article_params
    params.require(:article).permit(:subject)
  end

  def find_article
    @article = Article.find(params[:id])
    @subobject = @article
  end
end
