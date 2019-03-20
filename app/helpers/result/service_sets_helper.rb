module Result::ServiceSetsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers
  
  def results_select
    create_filtrable("results_select")
  end

  def run_id
    session[:filtr]['results_select_filtr'] ||= {}
    if params[:result_run_id]
      session[:filtr]['results_select_filtr']['result_run_id'] = Result::Run.friendly.find(params[:result_run_id]).try(:id) 
    else
      (session_filtr_params(results_select)['result_run_id'] || -1).to_i
    end
  end
  
  def service_set_id
    session[:current_id] ||= {}
    session[:current_id]['service_set_id'] = params[:service_set_id] if params[:service_set_id]
  end
  
  def service_id
    session[:current_id]['service_id']
  end
  
  def identical_services
#    @identical_services ||= 
    Result::ServiceSet.where(:run_id => run_id).pluck(:identical_services).flatten(2).uniq
  end
  
  def all_service_ids
#    @all_service_ids ||= 
    Result::ServiceSet.where(:run_id => run_id).pluck(:service_ids).flatten.uniq
  end

  def zero_string_condition
    if (optimization_params_session_info['show_zero_tarif_result_by_parts'] || 'false') == 'true'
      'true'
    else
      "price > 0.0 or call_id_count > 0"
    end
  end  
   
  def service_description(service_ids_1 = [])
    s_desc = {}
    service_ids = service_ids_1.map{|s| s.is_a?(String) ? s.split("_").map(&:to_i) : s }.flatten
#    @service_description ||= 
    TarifClass.where(:id => service_ids).select(:id, :name, :features, :slug).each do |row|
      s_desc[row[:id]] = {'service_name' => row[:name], 'service_http' => row[:features]['http'], 'slug' => row[:slug]}
    end
    s_desc
  end
    
  def result_service_sets(m_privacy, region_txt)
#    return @result_service_sets if @result_service_sets
    options = {:base_name => 'service_sets', :current_id_name => 'service_set_id', :id_name => 'service_set_id', :pagination_per_page => 10}
#    @result_service_sets = 
    model = Result::ServiceSet.includes(:operator, :tarif).where(:run_id => run_id).
      where(:tarif_id => TarifClass.privacy_and_region_where_with_default(m_privacy, region_txt)).
      order("price, array_length(tarif_options,0)")
    create_tableable(model, options)
  end
  
  def results_service_set
#    result_run_id_to_search = params[:result_run_id] || session_filtr_params(results_select)['result_run_id'].try(:to_i)
#    result_run_id_to_search = session_filtr_params(results_select)['result_run_id'].try(:to_i)
    raise(StandardError) if false
    Result::ServiceSet.includes(:operator, :tarif).where(:run_id => run_id, :service_set_id => service_set_id).first
  end
  
  def results_best_n_service_set(n = 5)
    best_n_service_sets = Result::ServiceSet.where(:run_id => session_filtr_params(results_select)['result_run_id']).
      order("price, array_length(tarif_options,0)").limit(n).pluck(:service_set_id)
    options = {:base_name => 'best_n_service_sets', :current_id_name => 'best_n_service_set_id', :id_name => 'service_set_id', :pagination_per_page => 10}
    create_tableable(Result::ServiceSet.includes(:operator, :tarif).
      where(:run_id => session_filtr_params(results_select)['result_run_id'], :service_set_id => best_n_service_sets).order("price, array_length(tarif_options,0)"), options)
  end
  
  def results_service_sets
#    return @results_service_sets if @results_service_sets
    options = {:base_name => 'service_sets', :current_id_name => 'service_set_id', :id_name => 'service_set_id', :pagination_per_page => 10}
#    @results_service_sets = 
    create_tableable(Result::ServiceSet.includes(:operator, :tarif).where(:run_id => session_filtr_params(results_select)['result_run_id']).
      order("price, array_length(tarif_options,0)"), options)
  end
  
  def if_show_aggregate_results
    create_filtrable("if_show_aggregate_results")
  end

  def result_services
    options = {:base_name => 'services', :current_id_name => 'service_id', :id_name => 'service_id', :pagination_per_page => 20}
#    @result_services ||= 
    create_tableable(Result::Service.where(:run_id => run_id, :service_set_id => service_set_id).
      where(zero_string_condition).order(price: :desc), options)
  end
  
  def result_service_categories
    options = {:base_name => 'service_categories', :current_id_name => 'service_category_name', :id_name => 'service_category_name', :pagination_per_page => 100}
#    @result_service_categories ||= 
    create_tableable(Result::ServiceCategory.where(:run_id => run_id, :service_set_id => service_set_id, :service_id => service_id).
      where(zero_string_condition).order(:fix_ids), options)
  end
  
  def result_agregates
    options = {:base_name => 'agregates', :current_id_name => 'aggregated_service_category_name', :id_name => 'service_category_name', :pagination_per_page => 100}
#    @result_agregates ||= 
    create_tableable(Result::Agregate.where(:run_id => run_id, :service_set_id => service_set_id).
      where(zero_string_condition).order(:fix_ids), options)
  end


  def calls_stat_options
    create_filtrable("calls_stat_options")
  end

  def calls_stat
    filtr = session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'} + ['fixed_payments']
    calls_stat_options = {"rouming" => 'true', "service" => 'true'} if calls_stat_options.blank?
    
     
    result_service_set = Result::ServiceSet.includes(:tarif, :run).where(:run_id => run_id, :service_set_id => service_set_id).first
    result_call_stat_hash = if result_service_set
      tarif = result_service_set.tarif
      operator_id = tarif.operator_id
      accounting_period = result_service_set.run.accounting_period
      privacy_id = m_privacy_id #tarif.privacy_id
      region_txt = m_region #tarif.region_txt
      Result::CallStat.where(:run_id => run_id, :operator_id => operator_id).first_or_create.calls_stat_array(accounting_period, privacy_id, region_txt, calls_stat_options)
    else
      {}
    end
    
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category', :pagination_per_page => 100}
    create_array_of_hashable(result_call_stat_hash, options )
  end
   
  def comparison_options
    create_filtrable("comparison_options")
  end

  def service_set_choicer
    create_filtrable("service_set_choicer")
  end

  def comparison_service_sets
    filtr = session_filtr_params(comparison_options)
    comparison_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    comparison_options = {"service" => 'true'} if comparison_options.blank?
    
    session_filtr_params_service_set_choicer = session_filtr_params(service_set_choicer)
    service_set_ids = ((session_filtr_params_service_set_choicer['result_service_set_id'] || {}).values.compact - [""])
    
    comparison_base = session_filtr_params_service_set_choicer['comparison_base']
    
#    raise(StandardError, [session_filtr_params_service_set_choicer['comparison_base'], comparison_base])
    options = {:base_name => 'comparison_service_sets', :current_id_name => 'global_category_id', :id_name => 'global_category_id', :pagination_per_page => 100}

    model = Result::Agregate.compare_service_sets_of_one_run({run_id => service_set_ids}, [:price], comparison_options, comparison_base)
    raise(StandardError, [
      model
    ]) if false
#    @comparison_service_sets ||= 
    create_array_of_hashable(model, options )
  end
  
  def set_back_path
    session[:back_path]['result_service_sets_detailed_results_path'] = case action_name
    when 'results'
      session[:back_path]['service_sets_result_return_link_to'] = ""
      'result_service_sets_results_path'
    when 'result'
      'result_service_sets_result_path'
    else
      'result_service_sets_result_path'
    end    
  end

  def service_sets_result_return_link_to    
    back_path = session[:back_path]['service_sets_result_return_link_to'] || 'result_runs_path'
    case back_path
    when 'comparison_optimization_path' 
      comparison = result_service_sets_model.first.try(:run).try(:comparison_group).try(:optimization) 
      comparison_optimization_path(hash_with_region_and_privacy({:id => comparison.slug})) if comparison
    when "tarif_optimizators_admin_index_path"; tarif_optimizators_admin_index_path(hash_with_region_and_privacy)
    else result_runs_path(hash_with_region_and_privacy)
    end
  end
  
  def service_sets_detailed_results_return_link_to    
    back_path = session[:back_path]['result_service_sets_detailed_results_path'] || 'result_service_sets_results_path'
    case back_path
    when 'result_service_sets_result_path'
      result_service_sets_result_path(hash_with_region_and_privacy({:result_run_id => results_service_set.try(:run).try(:slug)})) if results_service_set.try(:run)
    else
      result_service_sets_results_path(hash_with_region_and_privacy)
    end
  end
  
  def set_initial_breadcrumb_for_service_sets_result
    case session[:back_path]['service_sets_result_return_link_to']# || 'result_runs_path'
    when 'comparison_optimization_path'
      comparison_group = result_service_sets_model.first.try(:run).try(:comparison_group)
      comparison = comparison_group.try(:optimization)
      add_breadcrumb I18n.t(:comparison_optimizations_path), comparison_optimizations_path(hash_with_region_and_privacy)
      add_breadcrumb "#{comparison.try(:name)}, #{comparison_group.try(:name)}", comparison_optimization_path(hash_with_region_and_privacy({:id => comparison.slug})) if comparison
    when "tarif_optimizators_admin_index_path"; tarif_optimizators_admin_index_path(hash_with_region_and_privacy)
    when "result_runs_path"
      add_breadcrumb "Список описаний подборов", result_runs_path(hash_with_region_and_privacy)
      add_breadcrumb results_service_set.try(:run).try(:name), result_runs_path(hash_with_region_and_privacy)
    when "result_run_path"
    end
  end
    
  def set_initial_breadcrumb_for_service_sets_detailed_result
    case session[:back_path]['result_service_sets_detailed_results_path']# || 'result_service_sets_results_path'
    when 'result_service_sets_results_path'
      add_breadcrumb "Сохраненные результаты подбора", result_service_sets_results_path(hash_with_region_and_privacy)
      add_breadcrumb results_service_set.try(:run).try(:name), result_service_sets_results_path(hash_with_region_and_privacy)
    when 'result_service_sets_result_path'
      add_breadcrumb " Результаты подбора", 
        result_service_sets_result_path(hash_with_region_and_privacy({:result_run_id => results_service_set.try(:run).try(:slug)})) if results_service_set.try(:run)
    when 'result_runs_path'
      add_breadcrumb "Список описаний подборов", result_runs_path(hash_with_region_and_privacy)
      add_breadcrumb results_service_set.try(:run).try(:name), 
        result_run_path(hash_with_region_and_privacy({:id => results_service_set.try(:run).try(:slug)})) if results_service_set.try(:run)        
    end
  end
  
  def result_service_sets_model 
    Result::ServiceSet.includes(:operator, :tarif).where(:run_id => run_id).order("price, array_length(tarif_options,0)")
  end
  
  def optimization_params_session_info
    (session[:filtr] and session[:filtr]['optimization_params_filtr']) ? session[:filtr]['optimization_params_filtr'] : {}
  end

end
