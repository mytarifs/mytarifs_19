@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_total_all_post, :name => 'Совсем Всё (постоплатный)', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {
    :http => 'http://moskva.beeline.ru/customers/products/mobile/tariffs/details/sovsem-vse/',
    :phone_number_type => ["Федеральный и Московский (495 или 499)"],
    :payment_type => "Постоплатная",
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
  scg_bln_total_all_post_calls = @tc.add_service_category_group(
    {:name => 'scg_bln_total_all_post_calls' }, 
    {:name => "price for scg_bln_total_all_post_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 6000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #calls abroad included in tarif
  scg_bln_total_all_post_calls_abroad = @tc.add_service_category_group(
    {:name => 'scg_bln_total_all_post_calls_abroad' }, 
    {:name => "price for scg_bln_total_all_post_calls_abroad"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 600.0, :price => 0.0}, :window_over => 'month' } }
    )


  #sms included in tarif
  scg_bln_total_all_post_sms = @tc.add_service_category_group(
    {:name => 'scg_bln_total_all_post_sms' }, 
    {:name => "price for scg_bln_total_all_post_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 6000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #mms included in tarif
  scg_bln_total_all_post_mms = @tc.add_service_category_group(
    {:name => 'scg_bln_total_all_post_mms' }, 
    {:name => "price for scg_bln_total_all_post_mms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 6000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet included in tarif
  scg_bln_total_all_post_internet = @tc.add_service_category_group(
    {:name => 'scg_bln_total_all_post_internet' }, 
    {:name => "price for scg_bln_total_all_post_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 60000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet for add_speed_1gb option
  scg_bln_add_speed_1gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_1gb_bln_total_all_post' }, 
    {:name => "price for scg_bln_add_speed_1gb_bln_total_all_post"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 250.0} } }
    )

  #internet for add_speed_4gb option
  scg_bln_add_speed_3gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_3gb_bln_total_all_post' }, 
    {:name => "price for scg_bln_add_speed_3gb_bln_total_all_post"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 4000.0, :price => 500.0} } }
    )

#internet for auto_add_speed option
  scg_bln_auto_add_speed= @tc.add_service_category_group(
    {:name => 'scg_bln_auto_add_speed_bln_total_all_post' }, 
    {:name => "price for scg_bln_auto_add_speed_bln_total_all_post"}, 
    {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 75.0, :price => 20.0} } }
    )

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 6000.0} } })

  
#Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_regions
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_regions, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.9} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.9} } })

#Own and home regions, Calls, Outcoming, to_not_own_country
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls_abroad[:id])


#Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.95} } })

#Own and home regions, sms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own and home regions, sms, Outcoming, to_not_own country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.95} } })

#Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own and home regions, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own and home regions, mms, Outcoming, to_not_own_country
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_mms[:id])

#Own and home regions, Internet, _own_and_home_regions_rouming
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed] )


#Own country, Calls, Incoming
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own country, Calls, Outcoming, to_own_and_home_regions, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.95} } })

#Own country, Calls, Outcoming, to_own_and_home_regions, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.95} } })

#Own country, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.95} } })

#Own country, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.95} } })

#Own country, Calls, Outcoming, to_not_own_country
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_calls_abroad[:id])


#Own country, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own country, sms, Outcoming, to_own country
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own country, sms, Outcoming, to_not_own country
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.95} } })

#Own country, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own country, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own country, mms, Outcoming, to_not_own country
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })


#_sc_rouming_bln_all_russia_except_some_regions_for_internet, Internet, _sc_rouming_bln_all_russia_except_some_regions_for_internet
  category = {:uniq_service_category => 'own_country_regions/internet',  
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Bln_all_russia_except_some_regions_for_internet, :name => 'Билайн, Все регионы  кроме регионов с ограниченным интернетом' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_total_all_post_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed] )

#_sc_rouming_bln_bad_internet_regions, Internet, _sc_rouming_bln_all_russia_except_some_regions_for_internet
  category = {:uniq_service_category => 'own_country_regions/internet', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Bln_bad_internet_regions, :name => 'Билайн, Регионы с ограниченным интернетом' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.95} } })  


#all_world_rouming, Calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 30.0, :price => 0.0}, :window_over => 'day' } } )

#all_world_rouming, Calls, outcoming
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'month' } } )
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'month' } } )
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'month' } } )

#all_world_rouming, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 0.0}, :window_over => 'month' } } )

#all_world_rouming, internet
category = {:uniq_service_category => 'abroad_countries/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice,  
      :formula => {:params => {:max_sum_volume => 100.0, :price => 0.0}, :window_over => 'month' } } ) 


#SIC, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })

#Other countries, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })


@tc.add_tarif_class_categories

