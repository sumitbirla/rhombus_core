class Admin::System::ExtraPropertiesController < ApplicationController
  
  def create
    
    params[:extra_properties].each do |h|
      if h[:id].blank? 
        ep = ExtraProperty.new(
              extra_property_id: h[:extra_property_id],
              extra_property_type: h[:extra_property_type],
              name: h[:name],
              value: h[:value],
              sort: h[:sort])
      else
        ep = ExtraProperty.find(h[:id])
        ep.assign_attributes(name: h[:name], value: h[:value], sort: h[:sort])
      end
    
      if ep.is_empty?
        ep.destroy
      else
        ep.save
      end
    end
    
    flash[:info] = "Extra properties saved"
    redirect_to params[:redirect]
  end
  
end
