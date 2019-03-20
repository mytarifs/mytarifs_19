module Result::RunsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::SessionInitializers
  
  def m_region 
    if use_local_m_region_and_m_privacy
      session_filtr_params(region_txt_select)['region_txt'] || 'moskva_i_oblast'
    else
      super
    end            
  end
  
  def calculation_run_select
    create_filtrable("calculation_run_select")
  end

  def call_run_select
    create_filtrable("call_run_select")
  end

  def region_txt_select
    create_filtrable("region_txt_select")
  end

  def send_calls_by_mail_form
    create_filtrable("send_calls_by_mail_form")
  end

  def optimization_select_filtr
    create_filtrable("optimization_select_filtr")
  end

  def accounting_period_select_filtr
    create_filtrable("accounting_period_select_filtr")
  end

  def result_runs_table
    filtr = session_filtr_params(result_runs_select) || {}
    result_runs_to_show = Result::Run.includes(:user, :call_run, :comparison_group).order("result_runs.updated_at desc")
    if user_type == :admin
      result_runs_to_show = result_runs_to_show.where(:user_id => filtr['user_id']) if !filtr['user_id'].blank?
    else
      result_runs_to_show = result_runs_to_show.where(:user_id => current_or_guest_user_id)
    end
    result_runs_to_show = result_runs_to_show.where(:call_run_id => filtr['call_run_id'].to_i) if !filtr['call_run_id'].blank?
    result_runs_to_show = result_runs_to_show.where(:comparison_group_id => filtr['comparison_group_id'].to_i) if !filtr['comparison_group_id'].blank?
    
    options = {:base_name => 'result_runs', :current_id_name => 'result_run_id', :id_name => 'id', :pagination_per_page => 10}
    create_tableable(result_runs_to_show, options)
  end
  
  def result_runs_select
#    @result_runs_select ||= 
    create_filtrable("result_runs_select")
  end
  
  def check_if_allowed_delete_result_run
    message = "У вас минимально возможное количество описаний. Больше удалять нельзя."
    redirect_to( result_runs_path(hash_with_region_and_privacy), alert: message) if result_runs_count < (Result::Run.allowed_min_result_run(user_type) + 1)
  end
  
  def is_allowed_new_result_run?
    result_runs_count < allowed_new_result_run(user_type) ? true : false
  end
  
  def result_runs_count
   result_runs_table.model.count
  end
  
  def allowed_new_result_run(user_type = :guest)
    Result::Run.allowed_new_result_run(user_type)
  end
  
  def accounting_periods(call_run_id = nil) 
#    @accounting_periods ||= 
    Customer::Call.joins(:call_run).where("customer_call_runs.user_id = customer_calls.user_id").
      where(:call_run_id => (call_run_id || -1).to_i).
      select("customer_calls.description->>'accounting_period' as accounting_period").uniq
  end
  
  def create_result_run_if_not_exists
    Result::Run.create(:name => "Подбор тарифа №1", :description => "", :user_id => current_or_guest_user_id, :run => 1, 
      :optimization_type_id => 0) if !result_runs_table.model.present?
  end
  
  def set_back_path
    session[:back_path]['service_sets_result_return_link_to'] = 'result_runs_path'
  end
  
  def best_service_sets(result_run_id, result_number = 1, tarif_ids_to_limit_result = [])
    Result::ServiceSet.best_service_sets(result_run_id, result_number, tarif_ids_to_limit_result)
  end
  
  def user_params
    {
      :call_run_id => result_run.call_run_id,
      :user_id => current_or_guest_user.id,
      :operator_id => 0, #user_params_filtr_session_filtr_params['operator_id'].to_i,
#      :own_phone_number => (user_params_filtr_session_filtr_params['own_phone_number']),
      :region_id => (Category::MobileRegions[m_region]['region_ids'][0] || Category::Region::Const::Moskva).to_i,
      :region_txt => m_region,
      :privacy_id => m_privacy_id,
      :country_id => (1100).to_i, 
#      :accounting_period_month => (user_params_filtr_session_filtr_params['accounting_period_month']),
#      :accounting_period_year => (user_params_filtr_session_filtr_params['accounting_period_year']),
    }
  end
  
  def check_email_field(field)
    (field =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
  end
  
  def check_phone_field(field)
    field_to_check = field.scan(/\d+/).join("")
    (field_to_check =~ /\d{9}/)
  end
  
end
