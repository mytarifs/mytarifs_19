class Service::CategoryTarifClassesController < ApplicationController
  include Service::CategoryTarifClassesHelper
  helper Service::CategoryTarifClassesHelper

  before_action :set_model, only: [:show, :edit, :update, :destroy, :copy]
  before_action :check_service_category_tarif_class_params_before_update, only: [:edit, :update]

  def copy
    new_service_category_tarif_class = service_category_tarif_class.copy_full_category_tarif_class_definition
    redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => new_service_category_tarif_class.tarif_class_id}) ), notice: "#{self.controller_name.singularize.capitalize} was successfully copied."
  end
  
  def update
    check_result, message = check_first_service_category
    if check_result
      params['service_category_tarif_class']['uniq_service_category'] = Optimization::Global::Base::StructureName.new.name(global_categories_from_params(params["service_category_tarif_class"]['uniq_service_category']))

      params['service_category_tarif_class']['conditions'] ||= {}
      params['service_category_tarif_class']['conditions']['parts'] = [Optimization::Global::Base::StructureByPartsHelper.
        part_from_service_category_tarif_class(params['service_category_tarif_class'])]

      new_service_category_tarif_class_params = service_category_tarif_class_params.
        except("filtr_keys", 'copy_service_category_group_to_another_service', 'standard_service_id', 'privacy_id', 'service_id_to_copy_to')
#      new_service_category_tarif_class_params = service_category_tarif_class.attributes.deep_merge(new_service_category_tarif_class_params)
      service_category_tarif_class.assign_attributes(new_service_category_tarif_class_params)

      message = if service_category_tarif_class.save

        new_parts = ((service_category_tarif_class.tarif_class.try(:dependency).try(:[], "parts") || []) + params['service_category_tarif_class']['conditions']['parts']).uniq
        new_dependency =  service_category_tarif_class.tarif_class[:dependency].merge({:parts => new_parts} )
        service_category_tarif_class.tarif_class.update(:dependency => new_dependency)
        
        included_tarif_options = params['service_category_tarif_class']['conditions']['tarif_set_must_include_tarif_options']
        TarifClass.update_support_service_parts(included_tarif_options) if !included_tarif_options.blank?
        
        redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => service_category_tarif_class.tarif_class_id}) ), {notice: "#{self.controller_name.singularize.capitalize} was successfully updated."}
      else        
        redirect_to edit_service_category_tarif_class_path(hash_with_region_and_privacy({:id => params[:id]}) ), {alert: service_category_group.errors}
      end      
    else
      redirect_to edit_service_category_tarif_class_path(hash_with_region_and_privacy({:id => params[:id]}) ), alert: message
    end
  end
  
  def destroy
    service_category_tarif_class.destroy
    redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => service_category_tarif_class.tarif_class_id}) ), notice: "#{self.controller_name.singularize.capitalize} was successfully destroyed."
  end
      
  def set_model
    @service_category_tarif_class = if params[:id] 
      Service::CategoryTarifClass.find(params[:id])
    else  
      Service::CategoryTarifClass.new
    end

  end

  def service_category_tarif_class_params
    unless params["service_category_tarif_class"].blank?
      params.require("service_category_tarif_class").permit!
    else
      {}
    end
  end
        

end
