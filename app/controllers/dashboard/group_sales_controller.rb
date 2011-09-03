class Dashboard::GroupSalesController < Dashboard::ApplicationController

  before_filter :load_variant, :only => [:new, :create]

  def index
  end


  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def cancel
  end

  def complete
  end

  private
  def load_variant
  end
end
