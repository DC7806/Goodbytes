class ContentsController < ApplicationController
  before_action :find_content, except: [:index, :new, :create]
  before_action :find_article
  before_action :find_channel
  before_action :channel_member?

  def index
    @contents = @article.contents.order(:position)
    render partial: "shared/contents"
  end

  def create
    @content = Content.new(
      title: "title",
      desc: "description",
      layout: (params[:layout].to_s || 0),
      position: @article.contents.length
    )
    @content.article_id = @article.id
    
    unless @content.save
      head :no_ok
    end

  end

  def update
    @content.update(content_params)
  end

  def destroy
    @content_id = @content.id
    @content.delete
    @article.contents.order(:position).each.with_index do |content, index|
      content.update(position: index)
    end
  end

  private
  def find_content
    @content = Content.find(params[:id])
    puts @content
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
    params.require(:content).permit(:title, :desc, :position)
  end
end
