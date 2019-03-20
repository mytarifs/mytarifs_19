module HomeHelper
  def save_user_phone_from_params(row_phone_string)
    phone = (row_phone_string || "").to_s.scan(/\d+/).join("")
    phone = 'undefined' if phone.blank? or phone.split("").size < 10
    Customer::Info.general.where(:user_id => current_or_guest_user.id).
      first_or_create.update(:info => {:phones =>[ 
        :source => "from_sms", 
        :date => Time.new,
        :phone_number => phone]
      })
    phone
  end

end
