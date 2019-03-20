module ApplicationHelper::Authorization

  def current_user_id
    current_user.id
  end
   
  def current_or_guest_user_id
    current_or_guest_user.id
  end
  
  def current_user_admin?
    user_type == :admin
  end
    
  def authenticate_and_authorise
    skip_authencate = my_skip_authenticate
    authenticate_user! unless skip_authencate
  
    case
    when user_type == :admin
    when match_with_lists([:root_url, :external_api_processing, :api])
    when match_with_lists([:public_url])
    when (match_with_lists([:comparison]) and [:stranger, :guest, :trial, :user].include?(user_type))
    when (match_with_lists([:call_generation_and_parsing]) and [:stranger, :guest, :trial, :user].include?(user_type))      
    when match_with_lists([:customer_call_run_changing])
      if !Customer::CallRun.where(:id => params[:id], :user_id => current_or_guest_user_id).present?
        redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "Доступ к разделу сайта #{controller_path}/#{action_name} for #{user_type} ограничен")
      end
    when (match_with_lists([:tarif_optimization]) and [:stranger, :guest, :trial, :user].include?(user_type))
    when match_with_lists([:result_run_changing])
      if !Result::Run.where(:slug => params[:id], :user_id => current_or_guest_user_id).present? #or
#         !(Result::Run.where(:id => params[:id], :user_id => nil).present? and action_name == 'show')
        redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "Доступ к разделу сайта #{controller_path}/#{action_name} for #{user_type} ограничен.")
      end
    when match_with_lists([:any_user_actions_with_devise])
    when (match_with_lists([:new_user_actions_with_devise]) and user_type == :guest)
    when match_with_lists([:signed_user_confirming_email]) 
      redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "Вы пытаетесь получить доступ к чужому счету") if !signed_user_confirming_email
    when match_with_lists([:signed_user_actions_with_devise]) 
      redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "Вы пытаетесь получить доступ к чужому счету") if !match_param_user_with_signed_user
    when match_with_lists([:signing_user_actions_with_devise]) 
      redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "Вы пытаетесь получить доступ к чужому счету") if !match_param_user_with_signing_user
    when match_with_lists([:password_user_actions_with_devise]) 
      redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "У вас нет доступа к чужому счету") if !(match_param_user_with_signed_user and match_user_password)
    else 
      redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "Доступ к разделу сайта #{controller_path}/#{action_name} for #{user_type} ограничен .")
    end
  end 

  def my_skip_authenticate
    match_with_lists([:root_url, :external_api_processing, :api]) or 
    ([:bot].include?(user_type) and match_with_lists([:root_url, :public_url])) or 
    (user_type == :guest and match_with_lists([
        :root_url, :public_url, :new_user_actions_with_devise, :comparison, :call_generation_and_parsing, :tarif_optimization, ])) or
     match_with_lists([:customer_call_run_changing, :result_run_changing])
#    match_with_lists([:root_url, :public_url, :new_user_actions_with_devise, :call_generation_and_parsing, :tarif_optimization, :external_api_processing])
  end
  
  def allowed_request_origin
    match_with_lists([:root_url, :public_url, :call_generation_and_parsing, :tarif_optimization, :external_api_processing])
  end
  
  def signed_user_confirming_email
    current_or_guest_user.confirmation_token == params[:confirmation_token]
  end
  
  def match_param_user_with_signed_user
    param_user_id = (params[:id] || params[:user].try(:[], :id) || -1).to_i
    signed_user_id = current_or_guest_user ? current_or_guest_user.id.to_i : -2
    param_user_id == signed_user_id 
  end
    
  def match_param_user_with_signing_user
    param_user_id = (params[:id] || params[:user][:id] || -1).to_i
    signed_user_id = current_or_guest_user ? current_or_guest_user.id.to_i : -2
    param_user_id == signed_user_id or (current_user and current_user.password.blank?)
#    raise(StandardError, [param_user_id, signed_user_id, current_user])
  end
    
  def match_user_password
    params[:user] and current_or_guest_user and 
    (current_or_guest_user.valid_password?(params[:user][:current_password]) or (current_user and current_user.password.blank?) )
  end
    
  def match_with_lists(lists_to_match = [])
    result = false
    lists_to_match.each {|list| return result = true if match_with_action_list(list) }
    false
  end
  
  def match_with_action_list(action_list_name = {})
    action_list = action_lists[action_list_name]
    request_method = request.request_method.downcase
    if action_list[:methods].include?(request_method) or action_list[:methods].blank?
      if action_list[:actions] and action_list[:actions][controller_path] and 
          (action_list[:actions][controller_path].include?(action_name) or action_list[:actions][controller_path].blank?)
        return true
      end
    end
    raise(StandardError, [request_method, action_list, controller_path, action_name]) if action_list_name.to_sym == :comparison and
      controller_name == 'results1'
    false
  end
  
  def action_lists
    {
      :external_api_processing => {
        :methods => ['post'], :actions => {
          'customer/payments' =>['create', 'process_payment'],
        },
      },
      :api => {
        :methods => [], :actions => {
          'api/v1/fast_optimizations' =>['index', 'input_params', 'test'],
        },
      },
      :root_url => {
        :methods => ['get'], :actions => {
          'home' => ['index'],
        }
      },
      :public_url => {
        :methods => [], :actions => {
          'users/authentications' => [],
          'home' => ['index', 'short_description', 'detailed_description', 'update_tabs', 'news', 'change_locale', 
            'introduction', 'sitemap', 'contacts', 'tarif_description', 'introduction_after_first_calculations', 'search', 
            'send_service_introduction', 'check_phone', 'welcome',
            'choose_mobile_region', 'set_mobile_region'],
          'content/articles' => ['mobile_article', 'mobile_articles', 'questions_and_answers'],
          'customer/call_runs' =>['new', 'create', 'calls_as_json'],
          'customer/payments' => [ 'new', 'edit', 'show', 'update', 'wait_for_payment_being_processed'],
          'result/runs' => ['new', 'create',
            'new_calculation', 'edit_calculation', 'update_calculation', 'select_calls', 'upload_calls', 'send_calls_by_mail',
            'calls_parsing_calculation_status', 'generate_calls', 'accounting_period_select', 'optimization_select', 'optimization_options', 
            'calculate', 'calculation_status', 'new_simple_calculation', 'choose_your_tarif_with_our_help', 'generate_calls_from_simple_form'],
          'result/service_sets' => ['result', 'results', 'detailed_results', 'compare', 'report'],
          'customer/demands' => ['index', 'create', 'new', 'application_for_tele2_nmp', 'apply_for_tele2_nmp'],
          'errors' => ['error404', 'error422', 'error500'],
          'comparison/optimizations' =>['index', 'show', 'call_stat', 'choose_your_tarif_from_ratings', 'by_operator', 
            'show_by_operator', 'unlimited_rating', 'unlimited_rating_for_internet'],
          'comparison/fast_optimizations' => ['index', 'index_by_operator', 'index_for_planshet'],
          'tarif_classes' =>['index', 'show', 'by_operator', 'show_by_operator', 'unlimited_tarif_class', 
            'unlimited_tarif_classes', 'compare_tarifs', 'compare_tarifs_by_operator', 'compare_tarifs_for_planshet',
            'estimate_cost',
            'international_rouming_tarif_classes', 'country_rouming_tarif_classes', 'international_calls_tarif_classes', 'country_calls_tarif_classes',
            'pay_as_go_tarif_classes', 'planshet_tarif_classes', 'business_tarif_classes', 
#            'unlimited_internet_tarif_classes', 'planshet_pay_as_go_tarif_classes',
#            'planshet_unlimited_tarif_classes', 'planshet_pay_as_go_internet_tarif_classes', 'planshet_unlimited_internet_tarif_classes'
            ],
        }
      }, 
      :comparison => {
        :methods => ['get'], :actions => {
          'comparison/optimizations' =>['index', 'show'],
        }
      }, 
      :call_generation_and_parsing => {
        :methods => [], :actions => {
          'customer/calls' =>['index', 'set_calls_generation_params', 'set_default_calls_generation_params', 
            'generate_calls', 'choose_your_tarif_with_our_help', 'generate_calls_from_simple_form'],
          'customer/call_runs' =>['index'],
          'customer/history_parsers' => ['prepare_for_upload', 'upload', 'calculation_status'],
        }
      },
      :customer_call_run_changing => {
        :methods => [], :actions => {
          'customer/call_runs' =>['show', 'edit', 'update', 'destroy', 'call_stat'],
        }
      },
      :tarif_optimization => {
        :methods => [], :actions => {
          'result/runs' => ['index'],
        }
      },
      :result_run_changing => {
        :methods => [], :actions => {
          'result/runs' => ['show', 'edit', 'update', 'destroy'],
        }
      },
      :any_user_actions_with_devise => {
        :methods => [], :actions => {
          'users/sessions' => [],
        }
      },
      :new_user_actions_with_devise => {
        :methods => [], :actions => {
#          'users' => ['new', 'create'],
          'users/registrations' => ['new', 'create'],
          'devise/passwords' => ['new', 'create', 'edit', 'update'],
          'users/confirmations' => ['new', 'show', 'create', 'confirm'],
          'devise/unlocks' => ['new', 'show', 'create'],
        }
      },
      :signed_user_confirming_email => {
        :methods => [], :actions => {
          'users/confirmations' => ['new', 'show', 'create', 'confirm'],
        }
      },
      :signed_user_actions_with_devise => {
        :methods => [], :actions => {
          'devise/passwords' => ['edit', 'update'],
          'users' => ['show', 'edit'],
        }
      },
      :signing_user_actions_with_devise => {
        :methods => [], :actions => {
          'users/registrations' => ['show', 'edit', 'create'],
        }
      },
      :password_user_actions_with_devise => {
        :methods => ['post', 'put', 'patch'], :actions => {
          'users' => ['update'],
          'users/registrations' => ['update'],
        }
      },
    }
  end


  def user_type
    case
    when ['*/*', 'ANY_FORMAT'].include?(request.headers["CONTENT_TYPE"])
      :bot
    when session[:guest_user_id]
      :guest
    when (current_user and current_user.email == ENV["TARIF_ADMIN_USERNAME"])
      :admin
    when (current_user and current_user.encrypted_password.blank?)
      :trial
    when current_user
      :user
    else
      :stranger
    end
  end
  
end
