@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_all_for_200, :name => 'Всё за 200', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/tariffs/details/vse-za-200/',
    :buy_http => 'http://moskva.beeline.ru/shop/basket?shopProductId=111473',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :is_archived => true,
    :multiple_use => false
  } } )
  
#Добавление новых service_category_group
  #calls included in tarif
  scg_bln_all_for_200_calls = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_200_calls' }, 
    {:name => "price for scg_bln_all_for_200_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 300.0, :price => 0.0}, :window_over => 'month' } }
    )

  #sms included in tarif
  scg_bln_all_for_200_sms = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_200_sms' }, 
    {:name => "price for scg_bln_all_for_200_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet included in tarif
  scg_bln_all_for_200_internet = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_200_internet' }, 
    {:name => "price for scg_bln_all_for_200_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet for add_speed_1gb option
  scg_bln_add_speed_1gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_1gb_for_200_internet' }, 
    {:name => "price for scg_bln_add_speed_1gb_for_200_internet"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 250.0} } }
    )

  #internet for add_speed_4gb option
  scg_bln_add_speed_3gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_3gb_for_200_internet' }, 
    {:name => "price for scg_bln_add_speed_3gb_for_200_internet"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 4000.0, :price => 500.0} } }
    )

#internet for auto_add_speed option
  scg_bln_auto_add_speed= @tc.add_service_category_group(
    {:name => 'scg_bln_auto_add_speed_for_200_internet' }, 
    {:name => "price for scg_bln_auto_add_speed_for_200_internet"}, 
    {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 75.0, :price => 20.0} } }
    )

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 200.0} } })

  
#Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_region, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_own_and_home_regions => {:in => [@tc.tarif_region_id] }, :to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_home_region, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_own_and_home_regions => {:in => @tc.tarif_home_region_ids }, :to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.0} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Beeline] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, Calls, Outcoming, to_bln_international_1 (СНГ, Грузия), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_1, :name => 'Билайн, услуги СНГ, Грузия телефоны Билалайн' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 10.0, :price => 12.0}, :window_over => 'day' } } )

#Own and home regions, Calls, Outcoming, to_bln_international_8 (на другие телефоны стран СНГ (кроме Азербайджана, Беларуси), Грузии, Абхазии, Южной Осетии)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_8, :name => 'Билайн, услуги на другие телефоны стран СНГ (кроме Азербайджана, Беларуси), Грузии, Абхазии, Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 10.0, :price => 24.0}, :window_over => 'day' } } )

#Own and home regions, Calls, Outcoming, to_bln_international_9 (на телефоны Азербайджана, Беларуси)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_9, :name => 'Билайн, услуги Азербайджан, Беларусия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 10.0, :price => 24.0}, :window_over => 'day' } } )

#Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.5} } })

#Own and home regions, sms, Outcoming, to_own country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.5} } })

#Own and home regions, sms, Outcoming, to_own country, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Beeline] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.5} } })

#Own and home regions, sms, Outcoming, to_not_own_country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.45} } })


#Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.95} } })

#Own and home regions, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.95} } })

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed] )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 4, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseMonth,  
      :formula => {:params => {:max_sum_volume => 70.0, :price => 20.0} } } ) 

#Own country, Calls, Incoming
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own country, Calls, Outcoming, to_own_and_home_regions, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own country, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Beeline] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own country, mms, incoming
category = {:uniq_service_category => 'own_country_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own country, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.95} } })

#Own country, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.95} } })

#_sc_rouming_bln_all_russia_except_some_regions_for_internet, Internet
  category = {:uniq_service_category => 'own_country_regions/internet', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Bln_all_russia_except_some_regions_for_internet, :name => 'Билайн, Все регионы  кроме регионов с ограниченным интернетом' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_200_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed] )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 4, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseMonth,  
      :formula => {:params => {:max_sum_volume => 70.0, :price => 20.0} } } ) 

#_sc_rouming_bln_bad_internet_regions, Internet
  category = {:uniq_service_category => 'own_country_regions/internet', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Bln_bad_internet_regions, :name => 'Билайн, Регионы с ограниченным интернетом' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.95} } })  


@tc.add_tarif_class_categories
