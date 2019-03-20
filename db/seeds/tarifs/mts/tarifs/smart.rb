#Smart
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_smart, :name => 'Smart', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {
    :http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/smart/', 
    :buy_http => 'http://shop.mts.ru/tariff/redirect.php?ID=2117614&regionId=1826',
    :phone_number_type => ["Федеральный", "Городской"],
    :payment_type => "Предоплатная",
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],    
    },
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_smart_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 500.0, :price => 0.0}, :window_over => 'month' } }
    )

  #sms included in tarif
  scg_mts_smart_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 500.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet included in tarif
  scg_mts_smart_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 3000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet for add_speed_100mb option
  scg_mts_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_100mb_mts_smart' }, 
    {:name => "price for scg_mts_add_speed_100mb_mts_smart"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay, 
      :formula => {:params => {:max_sum_volume => 100.0, :price => 30.0} } }
    )

  #internet for add_speed_500mb option
  scg_mts_add_speed_500mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_500mb_mts_smart' }, 
    {:name => "price for scg_mts_add_speed_500mb_mts_smart"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 500.0, :price => 95.0} } }
    )

  #internet for add_speed_1gb option
  scg_mts_add_speed_1gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_1gb_mts_smart' }, 
    {:name => "price for scg_mts_add_speed_1gb_mts_smart"}, 
    {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 175.0} } }
    )

  #internet for add_speed_2gb option
  scg_mts_add_speed_2gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_2gb_mts_smart' }, 
    {:name => "price for scg_mts_add_speed_2gb_mts_smart"}, 
    {:calculation_order => 4, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 2000.0, :price => 300.0} } }
    )

  #internet for add_speed_5gb option
  scg_mts_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_5gb_mts_smart' }, 
    {:name => "price for scg_mts_add_speed_5gb_mts_smart"}, 
    {:calculation_order => 5, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 5000.0, :price => 450.0} } }
    )

#own region rouming    

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 450.0} } })

#All_russia_rouming, mms, Incoming
  category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

  category = {:uniq_service_category => 'own_country_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, mms, Outcoming
  category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  

  category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  

#All_world_rouming, mms, Incoming
  category = {:uniq_service_category => 'abroad_countries/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_world_rouming, mms, Outcoming
  category = {:uniq_service_category => 'abroad_countries/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  


#All_russia_rouming, Calls, Incoming
  category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })


#All_russia_rouming, Calls, Outcoming, to_own_and_home_region, to_own_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } }) #приоритет 2 из-за опции Везде как дома

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } }) #приоритет 2 из-за опции Везде как дома

#All_russia_rouming, Calls, Outcoming, to_own_country, to_own_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, Calls, Outcoming, to_own_country, to_not_own_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#All_russia_rouming, Calls, Outcoming, to_sic_country
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС' }}} 
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС' }}} 
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })

#All_russia_rouming, Calls, Outcoming, to_europe
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'услуги в Европу МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'услуги в Европу МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })

#All_russia_rouming, Calls, Outcoming, to_other_country
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Other_countries, :name => 'услуги в прочие страны МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 70.0} } })

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Other_countries, :name => 'услуги в прочие страны МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 70.0} } })

#All_russia_rouming, sms, Incoming
  category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

  category = {:uniq_service_category => 'own_country_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, sms, Outcoming, to_own_home_regions
  category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.0} } })

  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.0} } })

#All_russia_rouming, sms, Outcoming, to_own_country
  category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.8} } })

  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.8} } })

#All_russia_rouming, sms, Outcoming, to_not_own_country
  category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.25} } })

  category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.25} } })

#All_russia_rouming, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_100_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_1_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )
#TODO разобраться есть все-таки доступ к интернету при исчерпании лимита, или только с турбо-кнопками
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 6,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.9} } })

  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_100_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_1_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )
#TODO разобраться есть все-таки доступ к интернету при исчерпании лимита, или только с турбо-кнопками
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 6,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.9} } })

#All_russia_rouming, wap-internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeKByte, :formula => {:params => {:price => 2.75} } })

  category = {:uniq_service_category => 'own_country_regions/internet',}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeKByte, :formula => {:params => {:price => 2.75} } })

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга


#All world, sms, Incoming
  category = {:uniq_service_category => 'abroad_countries/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })


@tc.add_tarif_class_categories

  
