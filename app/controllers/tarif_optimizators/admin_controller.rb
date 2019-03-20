class TarifOptimizators::AdminController < ApplicationController
  include TarifOptimizators::AdminHelper
  helper TarifOptimizators::AdminHelper
  
  before_action :set_back_path, only: [:index]
  before_action :create_result_run_if_not_exists, only: [:index]
  before_action :update_call_run_on_result_run_change, only: [:index]
  before_action :check_if_optimization_options_are_in_session, only: [:index]

  before_action :check_if_customer_has_free_trials, only: :recalculate
  before_action :check_inputs_for_recalculate, only: [:recalculate, :recalculate_new]
  before_action :validate_tarifs, only: [:index, :recalculate, :recalculate_new]

  def index
    result_run = Result::Run.where(:id => session_filtr_params(calculation_choices)["result_run_id"]).first
    add_breadcrumb "Сохраненные подборы: #{result_run.try(:name)}", result_runs_path(hash_with_region_and_privacy)
    add_breadcrumb "Задание параметров для подбора администратором"#, tarif_optimizators_admin_index_path
  end
  
 def select_services
    session[:filtr]['service_choices_filtr'].merge!(Customer::Info::ServicesSelect.
      process_selecting_services(params['services_select_filtr'], m_privacy_id, m_region))
    session_filtr_params(services_select)
    redirect_to(hash_with_region_and_privacy({:action => :index}))
  end
  
  def calculation_status
    if tarif_calculation_progress_bar.finished?   
      redirect_to(hash_with_region_and_privacy({:action => :index}), :alert => "Расчет закончен")
    end
  end
  
  def recalculate_new
    options_1 = options.merge({:selected_service_categories => []})
    Optimizator::Runner.new(options_1).calculate
    redirect_to(hash_with_region_and_privacy({:action => :index}), :alert => "Расчет закончен")
  end
  
  def recalculate    
    update_customer_infos

    options_1 = options.merge({:selected_service_categories => []})
    update_result_run_on_calculation(options_1)
    optimizator = Optimization::Runner.new(options_1)
    optimizator.calculate
    
    if session_filtr_params_optimization_params['calculate_on_background'] == 'true' and
      session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'false'
      redirect_to(hash_with_region_and_privacy({:action => :calculation_status}))
    else
      redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => "Расчет выполнен. Можете перейти к просмотру результатов"})
    end    
  end 
  
  def check_inputs_for_recalculate     
#    init_for_memory_test

    if session_filtr_params(calculation_choices)['result_run_id'].blank?
      redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => "Выберите описание подбора тарифа"}) and return
    end

    call_run_id = session_filtr_params(calculation_choices)['call_run_id']
    if session_filtr_params(calculation_choices)['accounting_period'].blank? or
        !accounting_periods(call_run_id).map(&:accounting_period).include?(session_filtr_params(calculation_choices)['accounting_period'])
      redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => "Выберите период для расчета"}) and return
    end

    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      if session_filtr_params(services_for_calculation_select)["operator_id"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите оператора на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => message_for_blank_operator}) and return
      end

      if session_filtr_params(services_for_calculation_select)["tarif_to_calculate"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите тариф на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => message_for_blank_operator}) and return 
      end
    end
    
    if is_user_calculating_now
      message = "Мы для вас сейчас уже подбираем тариф. Подождите до окончания подбора, мы сообщим об этом письмом, если вы предоставили адрес"
      redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => message}) and return 
    end
  end
  
  def check_if_customer_has_free_trials
    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      if !customer_has_free_tarif_recalculation_trials?
        redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => "У Вас не осталось свободных попыток для расчета выбранных тарифа и опций, а только для подбора тарифа"}) and return
      end
    else
      if !customer_has_free_tarif_optimization_trials?
        redirect_to(hash_with_region_and_privacy({:action => :index}), {:alert => "У Вас не осталось свободных попыток для подбора тарифа, только для расчета выбранных тарифа и опций"}) and return
      end
    end 
  end
end
