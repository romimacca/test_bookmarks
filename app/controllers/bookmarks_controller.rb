class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @bookmarks = Bookmark.all
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
  end

  # GET /bookmarks/new
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  def getBookmarksByCategory
    current_category = Category.where(name: params[:category]).first
    # ternario
    if current_category == nil 
      render json: {"Error" => ['Categoria no existe']}
    else
      if current_category.private == true
          render json: { current_category.name => ['Esta categoria es privada']}
      else
        json_categories = {"data" => [] }
      
        cat_parent = { current_category.name => [] }
        json_categories["data"].push( cat_parent )

        if current_category.children.count > 0 
          current_category.children.each do |child|
            arr_bookmarks = child.bookmarks.pluck(:url)
            json_bookmarks = {child.name => arr_bookmarks }
            json_categories["data"][0][current_category.name.to_s].push(json_bookmarks)
          end

        else
          json_categories["data"][0][current_category.name.to_s].push(current_category.bookmarks.pluck(:url))
          
        end
        render json: json_categories
      end
    end
  end
  

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.save
    @bookmarks = Bookmark.all

    # respond_to do |format|
    #   if @bookmark.save
    #     format.html { redirect_to @bookmark, notice: 'Bookmark was successfully created.' }
    #     format.json { render :show, status: :created, location: @bookmark }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @bookmark.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to bookmarks_url, notice: 'Bookmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:bookmark).permit(:name, :url, :tag_id, :category_id)
    end
end
