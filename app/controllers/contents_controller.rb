class ContentsController < ApplicationController
  layout "content"
  before_action :find_channel
  before_action :channel_member?
  before_action :find_article, only: [:index, :new, :create]
  before_action :find_content, only: [:edit, :update, :destroy]

  def index
    @contents = @article.contents.order(create_at: :asc).includes(:contents)
  end

  def new
    @content = @article.contents.new
  end 

  def create
    @content = Content.new(content_params)
    @content.article_id = @article.id
    # @content = @article.contents.new(content_params)
    
    if @content.save
      redirect_to article_article_contents_index_path(article_id: @article.id)
    else
      render :new
    end
  end

  # def edit
  #   @contents = @article.contents.order(create_at: :asc).includes(:contents)
  #   render layout: "content"
  # end

  # def update
  #   render layout: "content"
  # end

  private
  def find_article
    @article = @channel.articles.find(params[:article_id])
    @subobject = @article
  end
  def find_content
    @content = Content.find(params[:id])
  end
  def content_params
    params.require(:content).permit(:title, :desc)
  end
end
