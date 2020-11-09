class Admin::System::AttributesController < Admin::BaseController

  def index
    @attributes = Attribute.where(entity_type: params[:type]).order("sort")
  end

  def new
    @attribute = Attribute.new
    @attribute.entity_type = params[:type]
    @attribute.name = 'New attribute'
    render 'edit'
  end

  def create
    @attribute = Attribute.new(attribute_params)

    if @attribute.save
      redirect_to action: 'index', type: @attribute.entity_type, notice: 'Attribute was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @attribute = Attribute.find(params[:id])
  end

  def edit
    @attribute = Attribute.find(params[:id])
  end

  def update
    @attribute = Attribute.find(params[:id])

    if @attribute.update(attribute_params)
      redirect_to action: 'index', type: @attribute.entity_type, notice: 'Attribute was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @attribute = Attribute.find(params[:id])
    @attribute.destroy
    redirect_to action: 'index', type: @attribute.entity_type, notice: 'Attribute has been deleted.'
  end


  private

  def attribute_params
    params.require(:attribute).permit!
  end


end
