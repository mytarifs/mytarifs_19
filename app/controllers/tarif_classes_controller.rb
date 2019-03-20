class TarifClassesController < ApplicationController
#  @new_actions = [:admin_tarif_class, :show_by_operator, :unlimited_tarif_class]
#  include Crudable
#  crudable_actions :all
  include TarifClassesHelper
  helper TarifClassesHelper, Service::CategoryTarifClassPresenter#, Service::CategoryGroupPresenter
  helper_method :tarif_class

  before_action :set_model, only: [:new, :create, :show, :edit, :update, :destroy, :copy, :admin_tarif_class, :show_by_operator, :unlimited_tarif_class, :change_status]
  before_action :check_m_region_and_m_privacy, only: [:show, :show_by_operator, :unlimited_tarif_class, 
      :index, :by_operator, :unlimited_tarif_classes, :international_rouming_tarif_classes,
      :country_rouming_tarif_classes, :international_calls_tarif_classes, :country_calls_tarif_classes, :pay_as_go_tarif_classes, :planshet_tarif_classes] 
  before_action :check_tarif_class_params_before_update, only: [:new, :create, :edit, :update]
  before_action :clean_tarif_class_description_region_and_support_services_filtrs, only: [:index, :by_operator, :unlimited_tarif_classes, :international_rouming_tarif_classes,
      :country_rouming_tarif_classes, :international_calls_tarif_classes, :country_calls_tarif_classes, :pay_as_go_tarif_classes, :planshet_tarif_classes]
  before_action :update_incompatibility_tarif_class, only: [:mass_edit_tarif_classes]
  before_action :change_incompatibility_value_tarif_class, only: [:mass_edit_tarif_classes]
  before_action :update_dependent_on_tarif_class, only: [:mass_edit_tarif_classes]
  before_action :update_general_features_tarif_class, only: [:mass_edit_tarif_classes]
  before_action :process_parsed_tarif_lists_filtr, only: [:parsed_tarif_lists]
  before_action :process_admin_category_groups_filtr_actions, only: [:admin_tarif_class]
  
  add_breadcrumb("Тарифы и опции", -> context {context.tarif_classes_path(context.hash_with_context_region_and_privacy(context)) }, except: [
      :compare_tarifs, :compare_tarifs_by_operator, :compare_tarifs_for_planshet, :estimate_cost, :index,
    ])
  add_breadcrumb( "Тарифы и опции", nil, only: ['index'])

  add_breadcrumb( "Сравнение тарифов", nil, only: ['compare_tarifs'])
  add_breadcrumb( "Сравнение тарифов", -> context {context.compare_tarifs_path(context.hash_with_context_region_and_privacy(context)) }, 
    only: ['compare_tarifs_for_planshet', 'compare_tarifs_by_operator'])  
  add_breadcrumb( "Для планшетов", nil, only: ['compare_tarifs_for_planshet'])

  add_breadcrumb( "Оценка стоимости пользования тарифом", nil, only: ['estimate_cost'])

  def estimate_cost
    if params[:tarif_class_id_to_estimate_cost]
      tarif_class = TarifClass.where(:id => params[:tarif_class_id_to_estimate_cost]).first
      session[:filtr]['estimate_cost_tarifs_filtr_filtr'] = {
        "region_txt" => m_region, 
        "operators" => {'0' => tarif_class.operator_id}, 
        "tarifs" => {'0' => tarif_class.id},
      } if tarif_class
    end
  end
  
  def compare_tarifs_by_operator    
    @operator = Category::Operator.where(:slug => params[:operator_id]).first
    add_breadcrumb operator.try(:name)
  end
  
  def change_status
    if tarif_class
      filtr = session_filtr_params(tarif_class_filtr)
      if !filtr['change_status_field_name'].blank?
        old_value = tarif_class.features[filtr['change_status_field_name']] or tarif_class.features[filtr['change_status_field_name']].blank? ? true : tarif_class.features[filtr['change_status_field_name']]
        tarif_class.features[filtr['change_status_field_name']] = !old_value
        tarif_class.save!
      end      
    end
    redirect_to tarif_classes_path(hash_with_region_and_privacy)
  end

  def copy
    if (params["region_to_copy"].blank? and tarif_class.region_txt) or (params["privacy_id_to_copy"].blank? and tarif_class.privacy_id)
      redirect_to params["fail_url"], notice: "Tarif was not copied - params = #{params}"
    else
      copy_tarif_class = CopyTarifClasses.new(tarif_class.region_txt, params["region_to_copy"], tarif_class.privacy_id, params["privacy_id_to_copy"])
      new_tarif_class = copy_tarif_class.copy_full_tarif_definition(tarif_class)
      copy_tarif_class.update_full_tarif_definition_with_new_region_privacy_and_service_info(new_tarif_class) if !copy_tarif_class.is_target_region_and_privacy_equal_to_source?
  
      redirect_to edit_tarif_class_path(hash_with_region_and_privacy({:id => new_tarif_class.id})), notice: "#{self.controller_name.singularize.capitalize} was successfully copied."
    end
  end
  
  def create
    new_tarif_class_params = tarif_class_params.merge("dependency" => tarif_class_params["dependency"].except("new_incompatibility_key", "incompatibility_keys"))
    tarif_class.assign_attributes(new_tarif_class_params)
    tarif_class.verify_all_services_in_tarif_description_are_integer
    if tarif_class.save
      redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => tarif_class.id})), notice: "#{self.controller_name.singularize.capitalize} was successfully created."
    else
      render action: 'new', error: tarif_class.errors
    end
  end

  def edit
    add_breadcrumb "Редактирование сервиса '#{tarif_class.try(:name)}'", edit_tarif_class_path(hash_with_region_and_privacy({:id => params[:id]}))
  end
  
  def update
    new_tarif_class_params = tarif_class_params.merge("dependency" => tarif_class_params["dependency"].except("new_incompatibility_key", "incompatibility_keys"))
    new_tarif_class_params.merge!({"features" => tarif_class.features.merge(new_tarif_class_params["features"])})

    tarif_class.assign_attributes(new_tarif_class_params)
    tarif_class.verify_all_services_in_tarif_description_are_integer
    if tarif_class.save
      redirect_to admin_tarif_class_path(hash_with_region_and_privacy({:id => tarif_class.id})), notice: "#{self.controller_name.singularize.capitalize} was successfully updated."
    else
      render action: 'edit', error: tarif_class.errors
    end
  end
  
  def destroy
    if tarif_class.publication_status == Content::Article::PublishStatus[:published]
      redirect_to tarif_classes_path(hash_with_region_and_privacy), notice: "#{tarif_class.try(:name)}, {tarif_class.try(:id)} is published and cannot be destroyed."
    else
      tarif_class.destroy
      redirect_to tarif_classes_path(hash_with_region_and_privacy), notice: "#{tarif_class.try(:name)}, {tarif_class.try(:id)} was successfully destroyed."
    end
  end
      
  def show
    session[:filtr]['tarif_class_description_support_services_filtr'] = {}  if !params['services_with_support_service_filtr'].blank?

    session_filtr_params(tarif_class_description_region_filtr)
    session_filtr_params(services_with_support_service_filtr)
    session_filtr_params(tarif_class_description_support_services_filtr)

    session[:filtr]['tarif_class_description_region_filtr'] = {} if session[:filtr]['tarif_class_description_region_filtr'].blank?

    add_breadcrumb "#{tarif_class.try(:name)}"
  end
  
  def show_by_operator
    session[:filtr]['tarif_class_description_support_services_filtr'] = {}  if !params['services_with_support_service_filtr'].blank?

    session_filtr_params(tarif_class_description_region_filtr)
    session_filtr_params(services_with_support_service_filtr)
    session_filtr_params(tarif_class_description_support_services_filtr)

    session[:filtr]['tarif_class_description_region_filtr'] = {} if session[:filtr]['tarif_class_description_region_filtr'].blank?

    @operator = Category::Operator.friendly.find(params[:operator_id])
    add_breadcrumb "#{@operator.try(:name)}", tarif_classes_by_operator_path(hash_with_region_and_privacy({:operator_id => @operator.slug}))
    add_breadcrumb "#{tarif_class.try(:name)}"
  end
  
  def unlimited_tarif_class
    session[:filtr]['tarif_class_description_support_services_filtr'] = {}  if !params['services_with_support_service_filtr'].blank?

    session_filtr_params(tarif_class_description_region_filtr)
    session_filtr_params(services_with_support_service_filtr)
    session_filtr_params(tarif_class_description_support_services_filtr)

    session[:filtr]['tarif_class_description_region_filtr'] = {} if session[:filtr]['tarif_class_description_region_filtr'].blank?

    add_breadcrumb "Безлимитные тарифы", unlimited_tarif_classes_path(hash_with_region_and_privacy)
    add_breadcrumb "#{tarif_class.try(:name)}"
  end
  
  def pay_as_go_tarif_classes
    add_breadcrumb "Тарифы без абонентской платы"
  end
  
  def planshet_tarif_classes
    add_breadcrumb "Тарифы для планшетов"
  end
  
  def unlimited_tarif_classes
    add_breadcrumb "Безлимитные тарифы"
  end
  
  def international_rouming_tarif_classes
    add_breadcrumb "Поездки по миру"
  end

  def country_rouming_tarif_classes
    add_breadcrumb "Поездки по России"
  end
  
  def international_calls_tarif_classes
    add_breadcrumb "Звонки в другие страны"
  end
  
  def country_calls_tarif_classes
    add_breadcrumb "Звонки в другие регионы"
  end

  def business_tarif_classes
    redirect_to( tarif_classes_path(hash_with_region_and_privacy({}, 'business', m_region)), :status => :moved_permanently)
  end
  
  def by_operator
    @operator = Category::Operator.friendly.find(params[:operator_id])
    add_breadcrumb "#{@operator.try(:name)}"
  end
  
  def parsed_tarif_lists
    parsed_tarif_lists_tarif_class_filtr
  end
   
  def check_m_region_and_m_privacy    
    if params[:m_region] == 'moskva_i_oblast' or params[:m_privacy] == 'personal'
      redirect_to( hash_with_region_and_privacy, :status => :moved_permanently)  
    end    
  end
  
  def if_to_make_tarif_class_page_canonical
    tarif_class_path(hash_with_region_and_privacy({:id => tarif_class.slug, :trailing_slash => false}) ) != request.path
  end
  
  def set_model
    @tarif_class = if params[:id] 
      TarifClass.friendly.find(params[:id])
    else  
      TarifClass.new
    end

  end

  def tarif_class_params
    unless params["tarif_class"].blank?
      params.require("tarif_class").permit!
    else
      {}
    end
  end
        

end
