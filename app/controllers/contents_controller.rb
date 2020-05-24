class ContentsController < ApplicationController
  layout "content"
  before_action :find_article, except: :destroy
  before_action :find_content, only: [:edit, :update]
  before_action :find_channel
  before_action :channel_member?

  def new
    @content = @article.contents.new
  end 

  def create
    @content = Content.new(content_params)
    @content.article_id = @article.id
    
    if @content.save
      redirect_to article_path(@article)
    else
      render :new
    end
  end

  def update
    if @content.update(content_params)
      redirect_to article_path(@article), notice: "更新成功"
    else
      render "articles/show"
    end
  end

  def destroy
    @content = Content.find(params[:id])

    if @content.delete
      @article = Article.find(params[:id])
      redirect_to article_path(article_id: @article.id), notice: "成功刪除此樣版"
    else
      render "articles/show"
    end 
  end

  private
  def find_article
    @article = Article.find(params[:article_id])
    @subobject = @article
  end

  def find_content
    @content = @article.contents.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:title, :desc)
  end
end
