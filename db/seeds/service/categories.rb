cat = []; crit = [];
#виды услуг
cat << {:id => _sc_tarif_service, :name => 'виды услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _sc_onetime, :name => 'разовые', :type_id => _common, :parent_id => _sc_tarif_service, :level => 1, :path => [_sc_tarif_service]}
cat << {:id => _tarif_switch_on, :name => 'подключение тарифа', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
#TODO откорректировать
  crit << {:id => _tarif_switch_on * 10 , :criteria_param_id => nil, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _one_time, :service_category_id => _tarif_switch_on}
           
cat << {:id => 203, :name => 'смена тарифа', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 204, :name => 'отключение тарифа', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 205, :name => 'подключение услуги', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 206, :name => 'отключение услуги', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 207, :name => 'подключение опции', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 208, :name => 'отключение опции', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 209, :name => 'смена номера', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 210, :name => 'смена оператора', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 211, :name => 'смена региона', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 212, :name => 'федеральный номер', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 213, :name => 'локальный номер', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 214, :name => 'регулярный отчет об операциях', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 215, :name => 'отчет об операциях по запросу', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 216, :name => 'доступ в личный интернет кабинет', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 217, :name => 'доступ в личный мобильный кабинет', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}

cat << {:id => _sc_periodic, :name => 'периодические', :type_id => _common, :parent_id => _sc_tarif_service, :level => 1, :path => [_sc_tarif_service]}
cat << {:id => _periodic_monthly_fee, :name => 'месячная абонентская плата', :type_id => _common, :parent_id => _sc_periodic, :level => 2, :path => [_sc_tarif_service, _sc_periodic]}

#TODO откорректировать
  crit << {:id => _periodic_monthly_fee * 10 , :criteria_param_id => nil, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _periodic, :service_category_id => _periodic_monthly_fee}
cat << {:id => _periodic_day_fee, :name => 'ежедневная плата', :type_id => _common, :parent_id => _sc_periodic, :level => 2, :path => [_sc_tarif_service, _sc_periodic]}

#TODO откорректировать
  crit << {:id => _periodic_day_fee * 10 , :criteria_param_id => nil, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _periodic, :service_category_id => _periodic_day_fee}

cat << {:id => _sc_phone_service, :name => 'телефонные', :type_id => _common, :parent_id => _sc_tarif_service, :level => 1, :path => [_sc_tarif_service]}


Service::Category.delete_all; Service::Criterium.delete_all;

ActiveRecord::Base.transaction do
  Service::Category.create(cat)
  Service::Criterium.create(crit)

#  Service::Category.batch_save(cat, {}) #create(cat)
#  Service::Criterium.batch_save(crit, {}) #create(crit)
end
