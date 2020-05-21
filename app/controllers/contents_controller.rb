class ContentsController < ArticlesController
  before_action :find_article
  before_action :find_content, only: [:edit, :update, :destroy]

  def index
    @contents = @article.contents.order(create_at: :asc).includes(:contents)
  end

  def new
    @content = Content.new
  end 

  def create
    @content = @article.contents.new(:content)
    
    if @content.save
      redirect_to organization_channel_article_content_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  private
  def find_content
    @content = Content.find(params[:id])
  end
end
