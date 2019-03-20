@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_sms_stihia, :name => 'SMS-стихия', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/sms_mms/sms_stihija.html#21255',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :sms_pakets_and_options_for_sms => [
        _mgf_sms_stihia, _mgf_100_sms, _mgf_paket_sms_100, _mgf_paket_sms_150, _mgf_paket_sms_200, _mgf_paket_sms_350, _mgf_paket_sms_500, _mgf_paket_sms_1000,
        _mgf_sms_stihia, _mgf_option_for_sms_s, _mgf_option_for_sms_l, _mgf_option_for_sms_m, _mgf_option_for_sms_xl]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip, _mgf_megafon_online,
      _mgf_go_to_zero, _mgf_sub_moscow, _mgf_around_world, _mgf_all_simple, _mgf_warm_welcome, _mgf_go_to_zero, _mgf_city_connection],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#sms included in tarif
  scg_mgf_sms_stihia = @tc.add_service_category_group(
    {:name => 'scg_mgf_sms_stihia' }, 
    {:name => "price for scg_mgf_sms_stihia"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 15.0}, :window_over => 'day' } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 30.0} } })  

#Own and home regions, sms, to_own_country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_sms_stihia[:id])

#Own and home regions, sms, to_own_country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_sms_stihia[:id])


@tc.add_tarif_class_categories

#Скидка действует только при нахождении в Московском регионе.
#Максимальный бесплатный трафик для пользователей скидки — 100 SMS-сообщений в сутки. После исчерпания указанного объёма до конца суток SMS-сообщения тарифицируются согласно вашему тарифному плану.
#Скидка «SMS-Стихия» доступна для подключения на тарифах линеек «Все мобильные», «Вызов», «МегаФон – Все включено», «МегаФон — Все включено 2012», «МегаФон-Онлайн», О`Хард», «Переходи на НОЛЬ», «Подмосковный», «Свобода слова», «Твоё время», «Твоя сеть», «Тёплый приём», на тарифах «FIX», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Ветеран», «Вокруг света», «Все просто», «Гибкий», «Домашний», «Единый», «За Три», «Контакт», «МегаФон-Логин», «МегаФон-Модем Плюс», «Международный», «Мобильный», «О`Лайт», «Первый Федеральный», «Приём Частный СИТИ», «Просто», «Просто для общения», «Ринг-Динг», «₽вый», «Своя сеть», «Связь городов», «Смешарики», «Студенческий», «ФиксЛАЙТ», а также отдельных корпоративных тарифах.
