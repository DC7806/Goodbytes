class ContentsController < ArticlesController
  layout "content"
  before_action :find_content, only: [:edit, :update, :destroy]
  before_action :find_article, only: [:index, :new, :create]

  def index
    @contents = @article.contents.order(create_at: :asc).includes(:contents)
  end

  def new
    @content = Content.new
  end 

  # def create
  #   @content = @article.contents.new(:content)
    
  #   if @content.save
  #     redirect_to organization_channel_article_content_path
  #   else
  #     render :new
  #   end
  # end

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
  end
  def find_content
    @content = Content.find(params[:id])
  end
end
