module Customer::InfoHelper
  include SavableInSession::Formable, SavableInSession::SessionInitializers

  def customer_info_form(type)
    create_formable(customer_info(type))
  end
  
  def customer_info(type)
    @customer_info ||= {}
    @customer_info[type] ||= Customer::Info.try(type).where(:user_id => params[:id]).first_or_create
  end

  def customer_infos
    @customer_infos ||= Customer::Info.where(:user_id => params[:id])
  end


end
