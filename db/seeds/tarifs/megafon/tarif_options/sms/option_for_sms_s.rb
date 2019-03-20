@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_option_for_sms_s, :name => 'Опция для SMS S', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/sms_mms/sms_options.html#29729',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :sms_pakets_and_options_for_sms => [
        _mgf_sms_stihia, _mgf_100_sms, _mgf_paket_sms_100, _mgf_paket_sms_150, _mgf_paket_sms_200, _mgf_paket_sms_350, _mgf_paket_sms_500, _mgf_paket_sms_1000,
        _mgf_sms_stihia, _mgf_option_for_sms_s, _mgf_option_for_sms_l, _mgf_option_for_sms_m, _mgf_option_for_sms_xl]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_mgf_be_as_home]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

  #sms included in tarif
  scg_mgf_option_for_sms_s_sms = @tc.add_service_category_group(
    {:name => 'scg_mgf_option_for_sms_s_sms' }, 
    {:name => "price for scg_mgf_option_for_sms_s_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 0.0}, :window_over => 'month' } }
    )

#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 100.0} } })

#Own and home regions, sms, to_own_and_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_option_for_sms_s_sms[:id])


#Tarif option 'Будь как дома'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, :formula => {:params => {:price => 15.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, sms, to_own_and_home_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_option_for_sms_s_sms[:id], :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  


@tc.add_tarif_class_categories

#Опции «SMS S», «SMS M» и «SMS L»:
#—Списание абонентской платы осуществляется в день подключения Опции и далее ежемесячно в день календарного подключения.
#—Возобновление объема SMS в рамках Опции происходит ежемесячно в день календарного подключения, неиспользованный объем SMS на следующий месяц не переносится.
#—SMS-сообщения в рамках Опции расходуются при отправке на номера МегаФон и других операторов Домашнего региона. Тарификация SMS-сообщений вне рамок Опции осуществляется согласно условиям Вашего тарифного плана.

#Опция «SMS XL»:
#—Абонентская плата списывается ежедневно с момента подключения Опции.
#—SMS-сообщения в рамках Опции расходуются при отправке на номера МегаФон и других операторов по всей России, кроме Республики Крым и г. Севастополь. Тарификация SMS-сообщений вне рамок Опции осуществляется согласно условиям Вашего тарифного плана.

#Все опции работают при нахождении Абонента в пределах Домашнего региона, на территории которого был заключен договор об оказании услуг связи.
#SMS-сообщения на номера контент-провайдеров и поставщиков прочих развлекательных услуг тарифицируются вне рамок Опции.
#Срок действия Опций не ограничен. Опция действует до момента отключения услуги абонентом.
#Неиспользованный объем SMS на следующий месяц не переносится.
