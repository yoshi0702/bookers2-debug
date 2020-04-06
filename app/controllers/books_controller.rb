class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user, only: [:edit, :update]

  def show
  	@book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
  end

  def index
    @book = Book.new
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @user = current_user
  end

  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @books = Book.all
    @book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		 flash[:notice] = "successfully created book!"#保存された場合の移動先を指定。
       redirect_to book_path(@book)
  	else
  		@books = Book.all
  		render :index
  	end
  end

  def edit
  	@book = Book.find(params[:id])
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		flash[:notice] = "successfully updated book!"
      redirect_to book_path(@book)
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render :edit
  	end
  end

  def delete
  	@book = Book.find(params[:id])
  	@book.destoy
  	flash[:notice] = "successfully delete book!"
    redirect_to books_path
  end

  private

  def book_params
  	params.require(:book).permit(:title,:body)
  end

end
