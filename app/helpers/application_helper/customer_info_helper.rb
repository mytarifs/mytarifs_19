module ApplicationHelper::CustomerInfoHelper

  def general_customer_info
    Customer::Info.general.where(:user_id => current_or_guest_user.id).first
  end

end
