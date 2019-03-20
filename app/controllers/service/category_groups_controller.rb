class Service::CategoryGroupsController < ApplicationController
  include Service::CategoryGroupsHelper
  helper Service::CategoryGroupsHelper

  before_action :set_model, only: [:destroy, :edit, :copy, :add]
  before_action :check_category_group_params_before_edit, only: [:edit]
  before_action :process_action_buttons, only: [:edit]

  def copy
    new_service_category_group = service_category_group.copy_full_category_definition
    redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => params[:tarif_class_id]}) ), notice: "#{self.controller_name.singularize.capitalize} was successfully copied."
  end
  
  def add
    message = if Service::CategoryGroup.add_full_category_definition(params[:tarif_class_id])
      {notice: "#{self.controller_name.singularize.capitalize} was successfully added."}
    else
      {error: "#{self.controller_name.singularize.capitalize} was not added."}
    end
    redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => params[:tarif_class_id]}) ), message
  end

  def destroy
    service_category_group.destroy
    redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => service_category_group.tarif_class_id}) ), notice: "#{self.controller_name.singularize.capitalize} was successfully destroyed."
  end
      
  def set_model
    @service_category_group = if params[:id] 
      Service::CategoryGroup.find(params[:id])
    else  
      Service::CategoryGroup.new
    end

  end

end
