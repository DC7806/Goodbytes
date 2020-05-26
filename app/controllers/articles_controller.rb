class ArticlesController < ApplicationController
  before_action :find_article, except: [:new, :create]
  before_action :find_channel
  before_action :channel_member?

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
    @contents = @article.contents.order(:position)
    render layout: "article"
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to article_path(@article), notice: "This article has been update."

    else
      render :edit
    end
  end

  def sort
    ids = params[:contents_ids].map{ |x| x.to_i }
    # 原本是一個一個查，那樣順序也不會有錯，但就是 N+1 query
    @contents = Content.where(id: ids).sort_by{ |obj| ids.index(obj.id) }
    @contents.each.with_index do |content, index|
      content.update(position: index)
    end
    render partial: "shared/contents"
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
