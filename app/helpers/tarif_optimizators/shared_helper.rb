module TarifOptimizators::SharedHelper
  def m_region 
    if use_local_m_region_and_m_privacy
      session_filtr_params(calculation_choices)['region_txt'] || 'moskva_i_oblast'
    else
      super
    end            
  end
  
  def calculation_choices
    create_filtrable("calculation_choices")
  end
  
  def user_priority
    Customer::Info::ServicesUsed.info(current_or_guest_user_id)['paid_trials'] = true ? 10 : 20
  end

  def new_run_id    
    Result::Run.where(:user_id => current_or_guest_user_id, :run => 1).first_or_create()[:id]
  end
  
  def customer_call_run_id
    customer_call_runs.present? ? customer_call_runs.first.id : -1
  end
  
  def customer_call_runs
    Customer::CallRun.where(:user_id => current_or_guest_user_id, :id => customer_call_run_ids_and_accounting_periods_with_generated_calls[:call_run_ids]).order("updated_at desc")
  end

  def customer_call_run_ids_and_accounting_periods_with_generated_calls    
    result = {:call_run_ids => [], :accounting_periods => []}
    Customer::Call.joins(:call_run).where(:customer_call_runs => {:user_id => current_or_guest_user_id}).select(:call_run_id).uniq.
      pluck(:call_run_id, "customer_calls.description->>'accounting_period'").each do |row|
        result[:call_run_ids] << row[0]; result[:accounting_periods] << row[1];
      end
    result
  end

  def accounting_period
    accounting_periods(customer_call_run_id).blank? ? -1 : accounting_periods(customer_call_run_id)[0]['accounting_period']
  end

  def accounting_periods(call_run_id = nil)
#    @accounting_periods ||= 
    Customer::Call.joins(:call_run).where("customer_call_runs.user_id = customer_calls.user_id").
      where(:call_run_id => (call_run_id || -1).to_i).
      select("customer_calls.description->>'accounting_period' as accounting_period").uniq
  end
  
  def result_runs_for_current_or_guest_user
    Result::Run.where(:user_id => current_or_guest_user_id)
  end

  def result_run_id
    if session_filtr_params(calculation_choices)['result_run_id'].blank?
#      session[:filtr][:calculation_choices_filtr] ||= {}
      session[:filtr]["calculation_choices_filtr"]['result_run_id'] = Result::Run.where(:user_id => current_or_guest_user_id).
        first_or_create(:name => "Подбор тарифа", :description => "", :user_id => current_or_guest_user_id, :run => 1, 
        :optimization_type_id => optimization_type_from_controller_name).id 
    end    
    session_filtr_params(calculation_choices)['result_run_id']  
#    session[:filtr]["calculation_choices_filtr"]['result_run_id']
  end
  
  def create_result_run_if_not_exists
    Result::Run.allowed_min_result_run(user_type).times.each do |i|
      create_hash = {:name => "Подбор тарифа №#{i}", :description => "", :user_id => current_or_guest_user_id, :run => 1, 
        :optimization_type_id => optimization_type_from_controller_name}
      if i == 0
        input = customer_call_run_ids_and_accounting_periods_with_generated_calls
        if input[:call_run_ids][0]
          create_hash.merge!(:call_run_id => input[:call_run_ids][0], :accounting_period => input[:accounting_periods][0])
        end
      end
      Result::Run.create(create_hash)
    end if !Result::Run.where(:user_id => current_or_guest_user_id).present?
  end
  
  def init_calculation_choices_after_first_creating_result_runs(call_run_id)
    accounting_period_from_call_run = Customer::Call.where(:call_run_id => call_run_id).limit(1).first.try(:description).try(:[], "accounting_period")
    update_hash = {
      :call_run_id => call_run_id, :accounting_period => accounting_period_from_call_run, 
      :name => "Пробный подбор тарифа", :description => "", :user_id => current_or_guest_user_id, :run => 1, :optimization_type_id => optimization_type_from_controller_name
    }
    result_run = Result::Run.where(:user_id => current_or_guest_user_id, :call_run_id => nil).limit(1).first_or_create
    result_run.update(update_hash)
    session[:filtr]["calculation_choices_filtr"] = {"result_run_id" => result_run.id, "call_run_id" => result_run.call_run_id, "accounting_period" => result_run.accounting_period} 
  end
    
  def update_call_run_on_result_run_change
    session_filtr_params_calculation_choices = session[:filtr]['calculation_choices_filtr']
    if params[:calculation_choices_filtr] and !params[:calculation_choices_filtr][:result_run_id].blank? and
      (session_filtr_params_calculation_choices.try(:[], 'call_run_id').blank? or params[:calculation_choices_filtr].try(:[], :result_run_id).blank?) and 
      (params[:calculation_choices_filtr].try(:[], :result_run_id) != session_filtr_params_calculation_choices.try(:[], 'result_run_id'))
      
      result_run = Result::Run.find(params[:calculation_choices_filtr][:result_run_id].to_i)
      params[:calculation_choices_filtr][:call_run_id] = result_run.call_run_id if result_run.call_run_id
      params[:calculation_choices_filtr][:accounting_period] = result_run.accounting_period if result_run.accounting_period       
    end
  end
  
  def update_result_run_on_calculation(options)
    session_filtr_params_calculation_choices = session_filtr_params(calculation_choices)
    session[:current_id] = {
      'call_run_id' => session_filtr_params_calculation_choices['call_run_id'].try(:to_i),
      'result_run_id' => session_filtr_params_calculation_choices['result_run_id'].try(:to_i)
      }
    Result::Run.find(session_filtr_params_calculation_choices['result_run_id'].to_i).update({
      :call_run_id => session_filtr_params_calculation_choices['call_run_id'],
      :accounting_period => session_filtr_params_calculation_choices['accounting_period'],
      :optimization_type_id => optimization_type_from_controller_name,
      :optimization_params => options[:optimization_params],
      :calculation_choices => options[:calculation_choices],
      :selected_service_categories => options[:selected_service_categories],
      :services_by_operator => options[:services_by_operator],
      :temp_value => options[:temp_value],
      :service_choices => (session_filtr_params(service_choices) if respond_to?(:service_choices)),
      :services_select => (session_filtr_params(services_select) if respond_to?(:services_select)),
      :services_for_calculation_select => (session_filtr_params(services_for_calculation_select) if respond_to?(:services_for_calculation_select)),
      :service_categories_select => (session_filtr_params(service_categories_select) if respond_to?(:service_categories_select)),
    })
  end
  
  def optimization_type_from_controller_name
    case controller_name
    when 'main'; 0
    when 'fixed_services'; 1
    when 'limited_scope'; 2
    when 'fixed_operators'; 3
    when 'all_options'; 4
    when 'admin'; 5
    when 'dddd'; 6 # reserved for comparisons
    else
      7
    end
  end

  def set_back_path
    session[:back_path]['service_sets_result_return_link_to'] = case controller_name
    when 'admin'; "tarif_optimizators_admin_index_path"
    else  "result_runs_path"
    end    
  end

end
