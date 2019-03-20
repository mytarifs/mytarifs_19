module ApplicationHelper::GuestUser
  
  def show_login?
    !['confirmations', 'registrations', 'sessions', 'users', 'passwords', 'unlocks'].include?(controller_name) and (user_type == :guest)
  end
  
  def guest_user?
    !current_user or (session[:guest_user_id] && session[:guest_user_id] == current_user.id)
  end
  
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  def guest_user(with_retry = true)
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private
  
  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    if (Customer::Info.where(:user_id => current_user.id).present? or Customer::Call.where(:user_id => current_user.id).present?)
      call_run_ids = Customer::Call.where(:user_id => session[:guest_user_id]).pluck(:call_run_id).uniq
      Customer::Call.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
      Customer::CallRun.where(:id => call_run_ids).update_all("user_id = #{current_user.id}")
      Result::Run.where(:user_id => session[:guest_user_id]).where.not(:accounting_period => nil).update_all("user_id = #{current_user.id}")
      if Customer::Info.general.where(:user_id => current_user.id).present?
        new_info = Customer::Info.general.where(:user_id => session[:guest_user_id]).first.try(:info) || {}
        old_general_info_record = Customer::Info.general.where(:user_id => current_user.id).first
        info_to_update = (old_general_info_record.info.blank? ? {} : old_general_info_record.info).deep_merge(new_info)
        old_general_info_record.update(:info => info_to_update)
      else
        Customer::Info.general.where(:user_id => session[:guest_user_id]).first_or_create.update({:user_id => current_user.id})
      end
    else
      Customer::Call.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
      Customer::CallRun.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
      Customer::Demand.where(:customer_id => session[:guest_user_id]).update_all("customer_id = #{current_user.id}")
      Customer::Info.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
      Customer::Info::ServicesUsed.update_free_trials_by_cash_amount(current_user.id, (100.0 / 0.98), false)
      Customer::Service.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
      Customer::Stat.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
      Customer::Transaction.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
      Result::Run.where(:user_id => session[:guest_user_id]).update_all("user_id = #{current_user.id}")
    end
  end

  def create_guest_user
    u = User.new(:name => "Гость", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
#    raise(StandardError, u.id) #create_customer_infos_services_used_if_it_not_exists
    u.skip_confirmation_notification!
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end  

end
