class DetailedOptimzationByEmail
  include Result::HistoryParsersHelper
  
  def parce_call_details(sender_email, file)
    user, user_info = find_user_from_sender_email_or_create(sender_email)

    message = check_uploaded_call_history_file(file)    
    return [message, user] if message[:file_is_good] == false

    user_params(user)    
    history_parser_runner = Calls::HistoryParser::Runner.new(user_params, parsing_params.merge({:calculate_on_background => false}))
    parser, message = history_parser_runner.find_operator_parser(file)    
    return [message, user] if message[:file_is_good] == false
    
    message = history_parser_runner.parse_file_for_phone_number(parser, file, true)
    
    message = history_parser_runner.recalculate_direct(parser, file, true)

    [message, user]
  end
  
  def find_user_from_sender_email_or_create(sender_email)
    where_hash = [
      "(info#>'{tasks, optimize_tarif_after_getting_call_details}')::jsonb ? '#{sender_email}'",
      "(info#>'{tasks, optimize_tarif_after_getting_call_details, #{sender_email}, status}')::text = '\"not_confirmed\"'"
    ]
    user_info = Customer::Info.general.where(where_hash.join(" and ")).first
    
    if user_info
      user = User.where(:id => user_info.user_id.try(:to_i)).first
      user = create_user(sender_email, user_info.user_id.try(:to_i)) if !user
      [user, user_info]
    else
      user = User.where(:email => sender_email).first
      user = create_user(sender_email) if !user
      [user, nil]
    end
  end
  
  def create_user(sender_email, user_id = nil)
    create_hash = {:email => sender_email}
    create_hash.merge!({:id => user_id}) if user_id

    u = User.new(create_hash)
    u.save!(:validate => true)    
    u
  end
  
  def user_params(user = nil)
    return @user_params if @user_params
    
    call_run = create_call_run(user)
    @user_params = {
      :call_run_id => call_run.id,
      :user_id => user.id,
      :operator_id => 0, #user_params_filtr_session_filtr_params['operator_id'].to_i,
#      :own_phone_number => (user_params_filtr_session_filtr_params['own_phone_number']),
      :region_id => (Category::Region::Const::Moskva).to_i, 
      :region_txt => m_region,
      :privacy_id => m_privacy_id,
      :country_id => (1100).to_i, 
#      :accounting_period_month => (user_params_filtr_session_filtr_params['accounting_period_month']),
#      :accounting_period_year => (user_params_filtr_session_filtr_params['accounting_period_year']),
    }
  end
  
  def create_call_run(user)
    call_run_name = "Загрузка детализации"
    source = 1
    Customer::CallRun.create(:user_id => user.id, :name => call_run_name, :source => source)
  end
  
  def user_type
    :user
  end
  
end