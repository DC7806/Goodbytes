class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_article, except: [:new, :create]
  before_action :find_channel, except: [:show]
  before_action :channel_admin?, only: [:destroy]
  before_action :channel_member?, except: [:show]
  before_action :give_default_header_and_footer, only: [:edit, :show]

  def new
    @article = @channel.articles.new
  end

  def create
    # 判斷頻道有沒有寫過文章？如果有則抓最後一篇的header跟footer來塞
    last_article = @channel.articles.last
    if last_article.present?
      header = last_article.header
      footer = last_article.footer
    else
      header = render_to_string "shared/template/header", layout: false
      footer = render_to_string "shared/template/footer", layout: false
    end

    @article = @channel.articles.new(article_params)

    # 把樣板render後的結果轉成純字串並存入article
    @article.header = header
    @article.footer = footer
    
    if @article.save
      redirect_to edit_article_path(@article), notice: "電子報新增成功。"
    else
      redirect_to new_article_path, alert: "電子報必須有名稱"
    end
  end

  def show
    @contents = @article.contents.order(:position)
    render "articles/_show", layout: "landing"
  end

  def edit
    if @article.deliver_time
      redirect_to read_article_path
    else
      @contents = @article.contents.order(:position)
      @link_groups = @channel.link_groups.includes(:saved_links).order(:position)
      render layout: "article"
    end
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

  def read
    @contents = @article.contents.order(:position)
    @link_groups = @channel.link_groups.includes(:saved_links).order(:position)

  end

  private
  def article_params
    params.require(:article).permit(:subject, :header, :footer)
  end

  def find_article
    @article = Article.find(params[:id])
    @subobject = @article
  end

  def give_default_header_and_footer
    unless @article.header and @article.footer
      @article.header = File.open("app/views/shared/template/header.html.erb").read
      @article.footer = File.open("app/views/shared/template/footer.html.erb").read
      @article.save
    end
  end
end
