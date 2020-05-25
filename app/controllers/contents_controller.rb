class ContentsController < ApplicationController
  layout "content"
  before_action :find_content, except: [:new, :create]
  before_action :find_article
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

    if @content.delete
      redirect_to article_path(@article), notice: "成功刪除此樣版"
    else
      render "articles/show"
    end 
  end

  private
  def find_content
    @content = Content.find(params[:id])
    @subobject = @content
  end

  def find_article
    if @content
      @article = @content.article
    elsif params[:article_id].present?
      @article = Article.find(params[:article_id])
    end
  end

  def content_params
    params.require(:content).permit(:title, :desc)
  end
end
