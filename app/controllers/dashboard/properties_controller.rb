class  Dashboard::PropertiesController < Dashboard::ApplicationController

  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    if (@property = Property.create!(params[:property]))
      redirect_to dashboard_properties_path, :notice => "Property created."
    else
      render :new
    end
  end

  def edit
    @property = Property.find(params[:id])
    authorize! :edit, @property
  end

  def update
    @property = Property.find(params[:id])
    authorize!(:update, @property)

    if @property.update_attributes(params[:property])
      redirect_to dashboard_properties_path, :notice => "Property updated."
    else
      render :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    authorize!(:destroy, @property)
    if @property.destroy
      flash.notice = "Property  destroed."
    else
      flash[:error] = "Property not destroed."
    end
    redirect_to dashboard_properties_path
  end

  # Looks like this action is unused
  def filtered
    @properties = Property.where('lower(name) LIKE ?', "%#{params[:q].mb_chars.downcase}%").order(:name)
    respond_with(@properties) do |format|
      format.html { render :template => "admin/properties/filtered.html.erb", :layout => false }
    end
  end

end
