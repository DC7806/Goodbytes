class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_article, except: [:new, :create]
  before_action :find_channel, except: [:show]
  before_action :channel_admin?, only: [:destroy]
  before_action :channel_member?, except: [:show]

  def new
    @article = @channel.articles.new
  end

  def create
    @article = @channel.articles.new(article_params)

    # 把樣板render後的結果轉成純字串並存入article
    @article.header = render_to_string "shared/template/header", layout: false
    @article.footer = render_to_string "shared/template/footer", layout: false
    
    if @article.save
      redirect_to edit_article_path(@article), notice: "電子報新增成功。"
    else
      render :new
    end
  end

  def show
    @contents = @article.contents.order(:position)
    render "articles/_show", layout: "landing"
  end

  def edit
    @contents = @article.contents.order(:position)
    render layout: "article"
  end

  def update
    unless @article.update(article_params)
      head :bad_request
    end
  end

  def sort
    ids = params[:contents_ids]
    # 原本是一個一個查，那樣順序也不會有錯，但就是 N+1 query
    @contents = @article.contents
                        .sort_by{ |obj| ids.index(obj.id.to_s) }
    @contents.each.with_index do |content, index|
      content.update(position: index)
    end
    render partial: "shared/contents"
  end

  def destroy
    @article.destroy  
    redirect_to channel_path, notice: "電子報刪除成功。"
  end

  def header
    
  end

  def footer

  end

  private
  def article_params
    params.require(:article).permit(:subject, :header, :footer)
  end

  def find_article
    @article = Article.find(params[:id])
    @subobject = @article
  end
end
