@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_all_included_s, :name => 'Мегафон все включено S', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {
    :http => 'http://moscow.megafon.ru/tariffs/alltariffs/all_inclusive/all_inclusive_s/s.html',
    :buy_http => 'http://moscow.megafon.ru/zakaz/?tariff=tp_vse_vklyucheno_s',
    :phone_number_type => ["Федеральный"],
    :payment_type => "Предоплатная",
    :tv_video_content => "1 фильм и пакет ТВ-каналов 'МегаФон'",
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],    
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )
  
#Добавление новых service_category_group
  #calls included in tarif
  scg_mgf_all_included_s_calls = @tc.add_service_category_group(
    {:name => 'scg_mgf_all_included_s_calls' }, 
    {:name => "price for scg_mgf_all_included_s_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice, 
      :formula => {:params => {:max_duration_minute => 300.0, :price => 0.0}, :window_over => 'month' } } )
      
  #sms/mms included in tarif
  scg_mgf_all_included_s_sms_mms = @tc.add_service_category_group(
    {:name => 'scg_mgf_all_included_s_sms_mms' }, 
    {:name => "price for scg_mgf_all_included_s_sms_mms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 300.0, :price => 0.0}, :window_over => 'month' } } )

  #internet included in tarif
  scg_mgf_all_included_s_internet = @tc.add_service_category_group(
    {:name => 'scg_mgf_all_included_s_internet' }, 
    {:name => "price for scg_mgf_all_included_s_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 2000.0, :price => 0.0}, :window_over => 'month' } } )

  #internet for add_speed_1gb option
  scg_mgf_add_speed_1gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_1gb_mgf_all_included_s' }, 
    {:name => "price for scg_mgf_add_speed_1gb_mgf_all_included_s"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 150.0} } } )

  #internet for add_speed_4gb option
  scg_mgf_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_5gb_mgf_all_included_s' }, 
    {:name => "price for scg_mgf_add_speed_5gb_mgf_all_included_s"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 5000.0, :price => 400.0} } } )

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 300.0} } })

  
#Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.6} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_sms_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.9} } })

#Own and home regions, sms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.9} } })


#Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.0} } })

#Own and home regions, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb] )

#Own country, Calls, Incoming
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })  

#Own country, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })  
  

#Own country, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })  

#Own country, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })  

#Own country, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })  

#Own country, , sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_sms_mms[:id])

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb] )


#Tarif option 'Везде Москва — в Центральном регионе'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny, :formula => {:params => {:price => 3.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_country_regions/sms_in',  
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.9} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own country
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.9} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_country_regions/mms_in', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 10.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 10.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Tarif option 'Будь как дома'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny, :formula => {:params => {:price => 15.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_country_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.9} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_own country
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.9} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  


@tc.add_tarif_class_categories
