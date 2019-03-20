module Customer::CallRunHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers
  include Shared::CallStat

  def call_runs_select
#    @call_runs_select ||= 
    create_filtrable("call_runs_select")
  end

  def call_run
#    raise(StandardError, [params[:id], Customer::CallRun.where(:id => params[:id]).first])
#    @call_run ||= 
    Customer::CallRun.includes(:user).where(:id => params[:id].try(:to_i)).first
  end
  
  def customer_call_runs
#    return @customer_call_runs if @customer_call_runs and @customer_call_runs.model.present?
    options = {:base_name => 'customer_call_runs', :current_id_name => 'call_run_id', :id_name => 'id', :pagination_per_page => 10}
    customer_call_runs_to_show = user_type == :admin ? 
      Customer::CallRun.includes(:user, :operator).query_from_filtr(session_filtr_params(call_runs_select)).order("customer_call_runs.updated_at desc") :
      Customer::CallRun.includes(:user, :operator).where(:user_id => current_or_guest_user_id).order("customer_call_runs.updated_at desc")
#    @customer_call_runs = 
    create_tableable(customer_call_runs_to_show, options)
  end
  
  def check_if_allowed_new_call_run
    message = "Вам не разрешено создавать более #{allowed_new_call_run(user_type)}  описаний"
    redirect_to( customer_call_runs_path(hash_with_region_and_privacy), alert: message) if !is_allowed_new_call_run?
  end
  
  def check_if_allowed_delete_call_run
    message = "У вас минимально возможное количество описаний. Больше удалять нельзя."
    redirect_to( customer_call_runs_path(hash_with_region_and_privacy), alert: message) if customer_call_runs_count < (Customer::CallRun.min_new_call_run(user_type) + 1)
  end
  
  def is_allowed_new_call_run?
    customer_call_runs_count < allowed_new_call_run(user_type) ? true : false
  end
  
  def customer_call_runs_count
    customer_call_runs.model.count
  end
  
  def allowed_new_call_run(user_type = :guest)
    Customer::CallRun.allowed_new_call_run(user_type)
  end

  def create_call_run_if_not_exists
    1.times.each do |i|
      Customer::CallRun.create(:name => "Загрузка детализации №#{i}", :source => 1, :description => "", :user_id => current_or_guest_user_id)
    end  if !customer_call_runs.model.present?
  end

  def account_period_choicer
    create_filtrable("account_period_choicer")
  end
  
  def account_period_options
    call_run.stat and call_run.stat.is_a?(Hash) ? call_run.stat.keys : [] 
  end

  def check_call_run_params_before_update
    puts params["customer_call_run_form"]
    if params["customer_call_run_form"]
      
      if params["customer_call_run_form"]['operator_id'].blank?
        params["customer_call_run_form"] = params["customer_call_run_form"].except('operator_id')
      else
        params["customer_call_run_form"]['operator_id'] = params["customer_call_run_form"]['operator_id'].to_i
      end

      if params["customer_call_run_form"]['init_params'].blank?
        params["customer_call_run_form"] = params["customer_call_run_form"].except('init_params')
      else
        if params["customer_call_run_form"]['init_params']['general'].blank?
          params["customer_call_run_form"]['init_params'] = params["customer_call_run_form"]['init_params'].except('general')
        else
          if params["customer_call_run_form"]['init_params']['privacy_id'].blank?
            params["customer_call_run_form"]['init_params'] = params["customer_call_run_form"]['init_params'].except('privacy_id')
          else
            params["customer_call_run_form"]['init_params']['privacy_id'] = params["customer_call_run_form"]['init_params']['privacy_id'].to_i
          end

          if params["customer_call_run_form"]['init_params']['region_txt'].blank?
            params["customer_call_run_form"]['init_params'] = params["customer_call_run_form"]['init_params'].except('region_txt')
          end
        end
        
      end 
    end
    
    puts params["customer_call_run_form"]
  end


end
