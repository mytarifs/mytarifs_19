class Result::RunsController < ApplicationController
#  @new_actions = [:prepare_calculation, :edit_calculation, :select_calls, :calls_parsing_calculation_status, :calculate, :calculation_status]

  include Result::RunsHelper, Result::HistoryParsersHelper, Result::HistoryParsersBackgroundHelper, Result::OptimizatorHelper, Result::CallsGeneratorHelper
  helper Result::RunsHelper, Result::HistoryParsersHelper, Result::HistoryParsersBackgroundHelper, Result::OptimizatorHelper, Result::CallsGeneratorHelper
  include SavableInSession::Tableable, SavableInSession::Modeble
  
  include Crudable
  crudable_actions :all
  
  before_action :check_before_friendly_url, only: [:show]
  before_action :create_result_run_if_not_exists, only: [:index]
  before_action :check_if_allowed_delete_result_run, only: [:destroy]
  before_action :set_back_path, only: [:index]
  
  before_action :init_background_process_informer, only: [:upload_calls, :calls_parsing_calculation_status]
  before_action :set_new_call_run_id, only: [:upload_calls, :generate_calls, :generate_calls_from_simple_form]
    
  before_action :update_usage_pattern, only: [:select_calls]
  before_action :setting_if_nil_default_calls_generation_params, only: [:select_calls, :generate_calls]
  before_action :setting_if_nil_simple_form_session_params, only: [:choose_your_tarif_with_our_help]

  add_breadcrumb I18n.t(:result_runs_path), -> context {context.result_runs_path(context.hash_with_context_region_and_privacy(context)) }, only: [:index, :new, :show, :edit]
  
  def generate_calls_from_simple_form
    
  end
  
  def choose_your_tarif_with_our_help
    add_breadcrumb "Выбор детализации звонков"#, result_detailed_calculations_choose_your_tarif_with_our_help_path(params[:id])

    session[:work_flow] = {:offer_to_provide_email => true, :path_to_go => result_detailed_calculations_new_path(hash_with_region_and_privacy)}
  end
  
  def new_simple_calculation
    result_run = Result::Run.where(:user_id => current_or_guest_user_id, :optimization_params => nil).
      first_or_create(:name => "Подбор тарифа", :description => "", :run => 1, :optimization_type_id => 0)

    redirect_to result_detailed_calculations_choose_your_tarif_with_our_help_path(hash_with_region_and_privacy({:id => result_run.slug}))
  end

  def calculation_status
    add_breadcrumb "Выбор детализации звонков", result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Выбор способа подбора тарифа", result_detailed_calculations_optimization_select_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Задание параметров подбора тарифа", result_detailed_calculations_optimization_options_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Выполнение вычислений по подбору тарифа и опций"#, result_detailed_calculations_calculation_status_path(params[:id])
    
    if tarif_calculation_progress_bar.finished?   
      redirect_to result_service_sets_report_path(hash_with_region_and_privacy({:result_run_id => params[:id], :service_set_id => best_service_sets(result_run.id).first.try(:service_set_id)})), :alert => "Расчет закончен"
    end
  end
  
  def calculate    
    check = final_check_before_optimization
    if !check[0]
      case check[2]
      when :no_calls
        redirect_to result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]})), alert: check[1]
      when :no_accounting_period
        redirect_to result_detailed_calculations_accounting_period_select_path(hash_with_region_and_privacy({:id => params[:id]})), alert: check[1]
      when :not_all_optimization_options
        redirect_to result_detailed_calculations_optimization_options_path(hash_with_region_and_privacy({:id => params[:id]})), alert: check[1]
      else
        redirect_to result_detailed_calculations_optimization_options_path(hash_with_region_and_privacy({:id => params[:id]})), alert: check[1]
      end      
    else
      update_result_run_on_calculation(options)
      optimizator = Optimizator::Runner.new(options) 
      optimizator.calculate
      if ["true", true].include?(options[:optimization_params]['calculate_on_background'])
        redirect_to result_detailed_calculations_calculation_status_path(hash_with_region_and_privacy({:id => params[:id]}))
      else
        redirect_to result_service_sets_report_path(hash_with_region_and_privacy({:result_run_id => params[:id], :service_set_id => best_service_sets(result_run.id).first.try(:service_set_id)})), :alert => "Расчет закончен"
      end      
    end     
  end
  
  def update_calculation
    respond_to do |format|
      if result_run.update(params.require(:result_run).permit!)
        format.html { redirect_to result_run_path(hash_with_region_and_privacy({:id => params[:id]})), notice: "#{self.controller_name.singularize.capitalize} was successfully updated."}
        format.js { redirect_to result_run_path(hash_with_region_and_privacy({:id => params[:id]})), notice: "#{self.controller_name.singularize.capitalize} was successfully updated." }
      else
        format.html { render action: 'edit', error: result_run.errors }
        format.js { render action: 'edit',  error: result_run.errors }
      end
    end
  end
  
  def optimization_options
    add_breadcrumb "Выбор детализации звонков", result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Выбор способа подбора тарифа", result_detailed_calculations_optimization_select_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Задание параметров подбора тарифа"#, result_detailed_calculations_optimization_options_path(params[:id])

    if params[:fixed_services_select_filtr].try(:[], "operator_id") != session[:filtr]["fixed_services_select_filtr"].try(:[], "operator_id")
      params[:fixed_services_select_filtr] = {"operator_id" => params[:fixed_services_select_filtr].try(:[], "operator_id")}
      session[:filtr]["fixed_services_select_filtr"] = {"operator_id" => params[:fixed_services_select_filtr].try(:[], "operator_id")}
    end
    
    if session[:filtr]["operators_select_filtr"].blank? and session_filtr_params(optimization_select_filtr)["optimization_type_id"].try(:to_i) == 3
      operator_id = result_run.call_run.try(:operator_id)
      operator_short_name = {1023 => 'tel', 1025 => 'bln', 1028 => 'mgf', 1030 => 'mts'}[operator_id]
      session[:filtr]["operators_select_filtr"] ||= {}
      session[:filtr]["operators_select_filtr"][operator_short_name] = 'true'
    end
  end
  
  def optimization_select
    add_breadcrumb "Выбор детализации звонков", result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Выбор способа подбора тарифа"#, result_detailed_calculations_optimization_select_path(params[:id])

    result_run.update(:optimization_type_id => (session_filtr_params(optimization_select_filtr)["optimization_type_id"] || 0))
  end
  
  def accounting_period_select
    add_breadcrumb "Выбор детализации звонков", result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Выбор периода детализации для расчетов"#, result_detailed_calculations_accounting_period_select_path(params[:id])
    
    accounting_periods_for_call_run = accounting_periods(result_run.call_run_id).map(&:accounting_period)
    chosen_accounting_period = session_filtr_params(accounting_period_select_filtr)["accounting_period"]    
    chosen_accounting_period = nil if !accounting_periods_for_call_run.include?(chosen_accounting_period)
    result_run.accounting_period = nil if !accounting_periods_for_call_run.include?(result_run.accounting_period)

    case
    when accounting_periods_for_call_run.size == 1
      result_run.update(:accounting_period => accounting_periods_for_call_run[0])
      redirect_to hash_with_region_and_privacy({:action => :optimization_select})
    when (chosen_accounting_period and chosen_accounting_period != result_run.accounting_period)
      result_run.update(:accounting_period => chosen_accounting_period)
    end
  end
  
  def generate_calls
    Calls::Generator.new(customer_calls_generation_params, user_params.stringify_keys).generate_calls
    call_run = Customer::CallRun.where(:id => result_run.call_run_id).first_or_create

    operator_id = customer_calls_generation_params[:general]['operator_id']
    call_run.update(:init_params => customer_calls_generation_params, :operator_id => operator_id.try(:to_i))
    call_run.calculate_call_stat
    redirect_to result_detailed_calculations_accounting_period_select_path(hash_with_region_and_privacy), notice: "Мы сгенерировали для вас звонки."
  end
  
  def calls_parsing_calculation_status
    add_breadcrumb "Выбор детализации звонков", result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Обработка детализации звонков"

    if !background_process_informer.calculating?   
      if Customer::Call.where(:call_run_id => result_run.call_run_id).present?
        redirect_to( hash_with_region_and_privacy({:action => :accounting_period_select}))
      else
        redirect_to( hash_with_region_and_privacy({:action => :select_calls}), {:notice => "Не загрузился ни один звонок. Выберите другую детализацию или сообщите нам"})
      end
    end
  end
  
  def upload_calls
    message = params[:call_history] ? check_uploaded_call_history_file(params[:call_history]) : {:file_is_good => false, 'message' => "Вы не выбрали файл для загрузки"}
    if message[:file_is_good] == true     
      
      updated_parsing_params = parsing_params.merge({'calculate_on_background' => true })
      
      history_parser_runner = Calls::HistoryParser::Runner.new(user_params, updated_parsing_params)
      
      parser, message = history_parser_runner.find_operator_parser(params[:call_history])

      redirect_to( hash_with_region_and_privacy({:action => :select_calls}), {:alert => message}) and return if !message[:file_is_good]

      message = history_parser_runner.parse_file_for_phone_number(parser, params[:call_history])
            
      if updated_parsing_params['calculate_on_background']
        message = history_parser_runner.recalculate_on_back_ground(parser, params[:call_history], true)
        if message[:file_is_good]
          redirect_to hash_with_region_and_privacy({:action => :calls_parsing_calculation_status}) 
        else
          redirect_to( hash_with_region_and_privacy({:action => :select_calls}), {:notice => message})
        end
      else      
        message = history_parser_runner.recalculate_direct(parser, params[:call_history], true) 
        redirect_to( hash_with_region_and_privacy({:action => :accounting_period_select}), {:notice => message})
      end
    else
      text_message = (message.is_a?(Hash) and !message.blank?) ? message['message'] : message
      redirect_to( hash_with_region_and_privacy({:action => :select_calls}), {:alert => text_message})  
    end    
  end
  
  def send_calls_by_mail
    user_info = session_filtr_params(send_calls_by_mail_form)
    if !check_email_field(user_info.try(:[], "email"))
      redirect_to result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]})), {:alert => "электронная почта указана неправильно"} and return
    end
    if !check_phone_field(user_info.try(:[], "phone"))
      redirect_to result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]})), {:alert => "телефонный номер указан неправильно"} and return
    end
    
    general_info = Customer::Info.general.where(:user_id => current_or_guest_user.id).first_or_create
    existing_tasks = general_info["tasks"].try(:[], "optimize_tarif_after_getting_call_details") || {}
    new_task = {user_info.try(:[], "email") => {
        :result_run_id => result_run.id,
        :email => user_info.try(:[], "email"),
        :phone => user_info.try(:[], "phone"),
        :status => "not_confirmed"
      }
    } 
    general_info.update(:tasks => {
      :optimize_tarif_after_getting_call_details => existing_tasks.deep_merge(new_task)
    })
    
    if [:trial, :user, :admin].include?(user_type) 
      if !current_or_guest_user.confirmed?
        message = "Мы отправили вам письмо для подтверждения электронной почты, так как ваша текущая почта еще не подтверждена"
        current_or_guest_user.send_confirmation_instructions
      end       
    else
      if User.where(:email => user_info["email"]).exists?
        redirect_to login_path, {:alert => "Пользователь с таким электронным адресом уже существует. Если это вы, то войдите"} and return
      else
        u = User.new(:email => user_info["email"], :name => user_info["email"])
        u.save!(:validate => true)
        sign_in(:user, u)
      end
    end
    redirect_to result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => params[:id]})), {:notice => "Мы зарегистрировали вашу заявку, ждем от вас детализацию."}
  end

  def select_calls
    add_breadcrumb "Выбор детализации звонков"#, result_detailed_calculations_select_calls_path(params[:id])

    chosen_call_run_id = session_filtr_params(call_run_select)["call_run_id"].try(:to_i)
    if chosen_call_run_id
      session[:filtr]['accounting_period_select_filtr_filtr'] = nil
      result_run.update(:call_run_id => chosen_call_run_id, :accounting_period => nil)
    end
    
    if params[:call_run_select_filtr]
      if params[:accounting_period_select_filtr_filtr]
        session[:filtr]['call_run_select_filtr'] ||= {}
        session[:filtr]['call_run_select_filtr']["call_run_id"] = params[:call_run_select_filtr][:call_run_id]
      else
        session[:filtr]['accounting_period_select_filtr_filtr'] = nil
        result_run.update(:call_run_id => chosen_call_run_id, :accounting_period => nil)
      end
    end

    if params[:accounting_period_select_filtr_filtr]
      session[:filtr]['accounting_period_select_filtr_filtr'] ||= {}
      session[:filtr]['accounting_period_select_filtr_filtr']["accounting_period"] = params[:accounting_period_select_filtr_filtr][:accounting_period]
    end

    if params[:optimization_select_filtr_filtr]
      session[:filtr]['optimization_select_filtr_filtr'] ||= {}
      session[:filtr]['optimization_select_filtr_filtr']["optimization_type_id"] = params[:optimization_select_filtr_filtr][:optimization_type_id]
    end
  end
  
  def new_calculation
    result_run = Result::Run.where(:user_id => current_or_guest_user_id, :optimization_params => nil).
      first_or_create(:name => "Подбор тарифа", :description => "", :run => 1, :optimization_type_id => 0)
    
    session[:filtr]['call_run_select_filtr'] = {"call_run_id" => result_run.call_run_id}     
    session[:filtr]['accounting_period_select_filtr_filtr'] = {"accounting_period" => result_run.accounting_period}     
    redirect_to result_detailed_calculations_select_calls_path(hash_with_region_and_privacy({:id => result_run.slug})), :status => :moved_permanently
  end
  
  def show
    add_breadcrumb result_run_form.model.try(:name)#, result_run_path(result_run_form.model)
  end
  
  def edit
    add_breadcrumb "Редактирование #{result_run_form.model.try(:name)}"#, edit_result_run_path(result_run_form.model)
  end
  
  def check_before_friendly_url
    @runn = Result::Run.friendly.find(params[:id])
    if @runn and request.path != result_run_path(hash_with_region_and_privacy({:id => @runn.slug, trailing_slash: false}))
      redirect_to result_run_path(hash_with_region_and_privacy({:id => @runn.slug, trailing_slash: true})), :status => :moved_permanently
    end if params[:id]
  end
  
  def result_run 
    return nil if !params[:id]
    @result_run ||= Result::Run.includes(call_run: :operator).friendly.find(params[:id])
  end
  
  def set_new_call_run_id
    if result_run.call_run_id.blank?
      if action_name == "upload_calls"
        call_run_name = "Загрузка детализации"
        source = 1
      else
        call_run_name = "Моделирование детализации"
        source = 0
      end
      call_run = Customer::CallRun.create(:user_id => current_or_guest_user.id, :name => call_run_name, :source => source)

      session[:filtr]['call_run_select_filtr']['call_run_id'] = call_run.id
      session[:filtr]['accounting_period_select_filtr_filtr'] = nil
      result_run.update(:call_run_id => call_run.id, :accounting_period => nil)
    end
  end

  def setting_if_nil_simple_form_session_params
    session[:form]["customer_call_simple_form"] = Customer::Call::SimpleForm.default_values.stringify_keys if session[:form]["customer_call_simple_form"].blank?
  end
  

end
