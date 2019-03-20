def access_methods_to_constant_service_categories
#ServiceCategories
  #rouming
  # standard service types
  _sc_tarif_service = 200;
  _sc_phone_service = 300;

  #one time services
  _sc_onetime = 201; 
  _tarif_switch_on = 202;
   
  #periodic services
  _sc_periodic = 280;
  _periodic_monthly_fee = 281; _periodic_day_fee = 282;
  
 #Parameters
  #parameters from customer_calls
  
  
  
  
  _call_description_time =     14; _call_description_duration =     15; _call_description_volume =            16;
  
   
  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_service_categories