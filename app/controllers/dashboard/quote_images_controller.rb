class Dashboard::QuoteImagesController < Dashboard::ApplicationController

  before_filter :load_data

  def index
  end

  def new
    @image = Image.new
    respond_to do |format|
      format.js  { render :layout => false }
    end
  end

  def create
    if (@image = Image.create(params[:image].merge({ :viewable => @quote})))
      redirect_to dashboard_quote_quote_images_path(@quote), :notice => "Image saved."
    else
      render :new
    end

  end

  def edit
    @image = @quote.images.find(params[:id])
  end

  def update
    @image = @quote.images.find(params[:id])
    if @image && (@image.update_attributes(params[:image].merge({ :viewable => @quote})))
      redirect_to dashboard_quote_quote_images_path(@quote), :notice => "Image updated."
    else
      render :edit
    end

  end

  def destroy
    @image = @quote.images.find(params[:id])
    @viewable = @image.try(:viewable)

    if @image.destroy
      flash.notice = "Image destroyed."
    else
      flash.notice = "Occured when destroying image."
    end
    render :text => flash.notice

  end

  def update_positions
    params[:positions].each do |id, index|
      Image.update_all(['position=?', index], ['id=?', id])
    end

    respond_to do |format|
      format.js  { render :text => 'Ok' }
    end
  end

  private

  def load_data
    @quote = current_user.quotes.find(params[:quote_id])
  end

end
