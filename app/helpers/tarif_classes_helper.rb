module TarifClassesHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers
  include TarifClassesHelper::AdminCategoryGroupsHelper, TarifClassesHelper::MassEditHelper, TarifClassesHelper::ParsedTarifListsHelper, 
          TarifClassesHelper::TarifClassUpdateHelper, TarifClassesHelper::TarifClassShowHelper

  def operator
    @operator
  end
  
  def tarif_class
    @tarif_class
  end
  
  def tarif_class_form
    create_formable(tarif_class)
  end    

  def compare_tarifs_filtr
    create_filtrable("compare_tarifs_filtr")
  end
  
  def expand_all_filtr
    create_filtrable("expand_all_filtr")
  end
  
  def compare_tarifs
    tarif_ids = (session_filtr_params(compare_tarifs_filtr)["tarifs"] || []).map{|item| item[1].try(:to_i)}.compact
#    raise(StandardError, [tarif_ids, compare_tarifs_filtr])
    result = {}
    TarifClass.includes(:operator).where(:id => tarif_ids).each do |tarif_class|
      result[tarif_class.id] = tarif_class
    end
    result
  end

  def unlimited_tarif_classes_filtr
    create_filtrable("unlimited_tarif_class")
#    raise(StandardError, session[:filtr])
  end
  
  def unlimited_tarif_classes
    filtr = session_filtr_params(unlimited_tarif_classes_filtr)
    filtr_on_operator = filtr['operator_id'].blank? ? "true" : {:operator_id => filtr['operator_id'].to_i}  
  
    tarif_ids = TarifClass.privacy_and_region_where_with_default(m_privacy, m_region).includes(:operator).unlimited_tarifs.pluck(:id).uniq
    include_services_in_tarif = Service::CategoryGroupPresenter.included_services_in_tarif(tarif_ids, m_region)

    hash_model = []
    
    model = TarifClass.includes(:operator).
      original_tarif_class.privacy_and_region_where_with_default(m_privacy, m_region).
      where(:id => tarif_ids).where(filtr_on_operator).where(is_service_archived(filtr))
    model.find_each do |item|
      next if include_services_in_tarif[item.id].blank?
      included_services = include_services_in_tarif[item.id].stringify_keys
      next if (filtr["max_duration_minute"] || 0.0).to_f >= (included_services["max_duration_minute"] || 10000000.0)
      next if (filtr["max_count_volume"] || 0.0).to_f >= (included_services["max_count_volume"] || 10000000.0)
      next if (filtr["max_sum_volume"] || 0.0).to_f >= (included_services["max_sum_volume"] || 10000000.0)
      hash_model << item.attributes.merge(included_services).merge({"operator_name" => item.operator.name, "operator_slug" => item.operator.slug})     
    end
    
    hash_model.sort_by!{|h| (h["max_duration_minute"].try(:to_f) || 0.0)}
    
    options = {:base_name => 'unlimited_tarif_classes', :current_id_name => 'unlimited_tarif_class_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_array_of_hashable(hash_model, options)
  end

  def tarif_class_by_operator_filtr
    create_filtrable("tarif_class_by_operator")
#    raise(StandardError, session[:filtr])
  end
  
  def tarif_classes_by_operator
    filtr = session_filtr_params(tarif_class_by_operator_filtr)
    filtr.extract!('operator_id')
    
    model = TarifClass.includes(:operator, :privacy, :standard_service).joins(:operator).
      original_tarif_class.privacy_and_region_where_with_default(m_privacy, m_region).
      where(:categories => {:slug => params[:operator_id]}).query_from_filtr(filtr).
      where(where_for_service_category(filtr)).
      where(is_service_archived(filtr)).
      where(service_features_not_blank)

    model = model.service_is_published if user_type != :admin

    options = {:base_name => 'tarif_classes_by_operator', :current_id_name => 'tarif_class_by_operator_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end

  def pay_as_go_tarif_class_filtr
    create_filtrable("pay_as_go_tarif_class")
#    raise(StandardError, session[:filtr])
  end
  
  def pay_as_go_tarif_classes
    filtr = session_filtr_params(pay_as_go_tarif_class_filtr)
    
    tarif_ids = TarifClass.includes(:operator).
      original_tarif_class.privacy_and_region_where_with_default(m_privacy, m_region).
      unlimited_tarifs.pluck(:id).uniq
    
    model = TarifClass.includes(:operator, :privacy, :standard_service).
      original_tarif_class.privacy_and_region_where_with_default(m_privacy, m_region).
      query_from_filtr(filtr).
      where(where_for_service_category(filtr)).
      where(is_service_archived(filtr)).
      where(service_features_not_blank).
      where.not(:tarif_classes => {:id => tarif_ids}).
      where(:standard_service_id => TarifClass::ServiceType[:tarif])
    model = model.service_is_published if user_type != :admin
    
    options = {:base_name => 'pay_as_go_tarif_classes', :current_id_name => 'pay_as_go_tarif_class_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end

  def tarif_class_by_service_category_filtr(service_category)
    create_filtrable("#{service_category}_tarif_class")
#    raise(StandardError, session[:filtr])
  end
  
  def tarif_classes_by_service_category(service_category)
    filtr = session_filtr_params(tarif_class_by_service_category_filtr(service_category))
    
    model = TarifClass.includes(:operator, :privacy, :standard_service).
      original_tarif_class.privacy_and_region_where_with_default(m_privacy, m_region).
      where(is_service_archived(filtr)).
      where(service_features_not_blank)
    model = model.where(:operator_id => filtr['operator_id'].to_i) if !filtr['operator_id'].blank?
    model = model.service_is_published if user_type != :admin
    
    special_and_common_services_ids = [:common_service, :special_service].map{|t| TarifClass::ServiceType[t]}
    
    tarif_ids_by_category = model.to_service_categories(special_and_common_services_ids).try(:[], service_category.to_sym)
    tarif_ids_by_category = if filtr['service_type'].blank?
      tarif_ids_by_category[:all_service_types]
    else
      tarif_ids_by_category[filtr['service_type'].to_sym]
    end     
    
    model = TarifClass.includes(:operator, :privacy, :standard_service).where(:id => tarif_ids_by_category)
    
    options = {:base_name => "#{service_category}_tarif_classes", :current_id_name => "#{service_category}_tarif_classes_id", :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end
  
  def planshet_tarif_class_filtr
    create_filtrable("planshet_tarif_class")
#    raise(StandardError, session[:filtr])
  end
  
  def planshet_tarif_classes
    filtr = session_filtr_params(planshet_tarif_class_filtr)
    
    model = TarifClass.includes(:operator, :privacy, :standard_service).
      original_tarif_class.privacy_and_region_where_with_default(m_privacy, m_region).
      query_from_filtr(filtr).
      where(where_for_service_category(filtr)).
      where(is_service_archived(filtr)).
      where(service_features_not_blank).
      where(service_is_recommended_for_planshet)
    model = model.service_is_published if user_type != :admin
    
    options = {:base_name => 'planshet_tarif_classes', :current_id_name => 'planshet_tarif_class_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end

  def tarifs_to_update_select_filtr
    create_filtrable("tarifs_to_update_select")
  end
  
  def incompatibility_tarif_class_filtr
    create_filtrable("incompatibility_tarif_class")
  end
  
  def incompatibility_change_tarif_class_filtr
    create_filtrable("incompatibility_change_tarif_class")
  end
  
  def dependent_on_tarif_class_filtr
    create_filtrable("dependent_on_tarif_class")
  end
  
  def all_dependent_on_tarif_class_filtr
    create_filtrable("all_dependent_on_tarif_class")
  end
  
  def general_features_tarif_class_filtr
    create_filtrable("general_features_tarif_class")
  end
  
  def calculation_options_filtr
    create_filtrable("calculation_options")
  end
  

  def tarif_class_filtr
    create_filtrable("tarif_class")
  end
  
  def tarif_classes
    filtr = session_filtr_params(tarif_class_filtr)
    
    model = TarifClass.includes(:operator, :privacy, :standard_service).
      query_from_filtr(filtr).
      where(where_for_service_category(filtr)).
      where(is_service_archived(filtr))
      
    model = model.payment_type(filtr['payment_type']) if !filtr['payment_type'].blank?
    if user_type == :admin and filtr['show_as_for_not_admin'] != 'true'
      chosen_regions = (filtr['regions'] || []) - ['']
      if chosen_regions.blank?
        model = model.privacy_and_region_where_with_default(m_privacy, m_region)
      else
        model = model.regions(chosen_regions, filtr['regions_filtr_type'])
      end
      model = model.is_service_published?(filtr['status_id']) if !filtr['status_id'].blank?
      model = model.for_parsing(filtr['for_parsing']) if !filtr['for_parsing'].blank?
      model = model.excluded_from_optimization(filtr['excluded_from_optimization']) if !filtr['excluded_from_optimization'].blank?
      model = model.original_tarif_class if filtr['hide_secondary_tarif_class'] == 'true'
    else
      model = model.
        original_tarif_class.privacy_and_region_where_with_default(m_privacy, m_region).
        service_is_published.where(service_features_not_blank)
    end
    
    
    options = {:base_name => 'tarif_classes', :current_id_name => 'tarif_class_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end
  
  def where_for_service_category(filtr)
    category = filtr.extract!('dependency_parts')['dependency_parts']
    category.blank? ? "true" : "(dependency->>'parts')::jsonb ?& array['#{category}']"
  end
  
  def service_features_not_blank
    "tarif_classes.dependency is not null"
  end
  
  def service_is_recommended_for_planshet
    "(features->>'recommended_for_planshet')::text is not null and ((features->>'recommended_for_planshet')::text)::boolean = true"
  end
  
  def is_service_archived(filtr)
    is_archived = filtr.extract!('dependency_is_archived')['dependency_is_archived']
    case is_archived
      when is_archived.blank?
        "true"
      when 'false' 
        "(dependency->>'is_archived')::boolean = false or (dependency->>'is_archived') is null"
      when 'true'
        "(dependency->>'is_archived')::boolean = true"
      end     
  end

  def tarif_category_txt_from_standard_service_id(standard_service_id)
    case standard_service_id
    when TarifClass::ServiceType[:tarif]
      "+/-/-"
    when TarifClass::ServiceType[:special_service]
      "-/+/-"
    else
      "-/-/+"
    end.html_safe      
  end  

  def estimate_cost_tarifs_filtr
    create_filtrable("estimate_cost_tarifs_filtr")
  end
  
  def fast_optimization_options_form
    create_filtrable("fast_optimization_options_form")
  end
  
  def fast_optimization_options
    fast_optimization_presenter.options_presentation
  end
  
  def fast_optimization_results(result_type, result_number, tarif_id = nil, tarif_ids_to_limit_result = [])
    optimization_params = session_filtr_params(fast_optimization_options_form)
    raise(StandardError, [
      tarif_ids_to_limit_result,
      session_filtr_params(fast_optimization_options_form)
    ]) if false
    fast_optimization_presenter.result_presentation(optimization_params, result_type, result_number, tarif_id, tarif_ids_to_limit_result)
  end
  
  def fast_optimization_presenter
    Comparison::FastOptimizationPresenter.new(:only_own_home_region, m_privacy, m_region)
  end
  
  def clean_tarif_class_description_region_and_support_services_filtrs
    session[:filtr]['tarif_class_description_region_filtr'] = {}
    session[:filtr]['tarif_class_description_support_services_filtr'] = {}
    session[:filtr]["services_with_support_service_filtr"] = {}
  end
  

end
