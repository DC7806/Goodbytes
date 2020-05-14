class ArticlesController < ApplicationController
  before_action :find_mail, only: [:edit, :update, :show, :destroy]

  def index
    @mails = Article.order('created_at DESC')
  end

  def new
    @mail = Article.new
  end

  def create
    @mail = Article.new(mail_params)

    if @mail.savc
      redirect_to @mail, notice: "The mail has been created."
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
    @mail.destroy if @mail
    redirect_to articles_path, notice: "This mail has been delete."
  end

  private
  def mail_params
    params.require(:mail).permit(:subject)
  end

  def find_mail
    @mail = Article.find(params[:id])
  rescue
    redirect_to article_path, notice: "Sorry we cannot find this email."
  end
end
