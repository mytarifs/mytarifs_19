@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_sub_moscow, :name => 'Подмосковный', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/alltariffs/any_operator/podmoskovnyy/podmoskovnyy.html',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :prerequisites => [],
    :multiple_use => false
  } } )
  
#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })

  
#Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own regions, Calls, Outcoming, to_own_and_home_region
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:own_and_home_regions => {:in => [@tc.tarif_region_id] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
    :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 2.6, :price_1 => 1.6} } } )

#Home regions, Calls, Outcoming, to_own_and_home_region
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
 :filtr => {:own_and_home_regions => {:in => @tc.tarif_home_region_ids }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
    :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 1.6, :price_1 => 0.6} } } )

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 6.5} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 12.5} } })

#Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, Outcoming, to_all_country_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 10.0, :price => 1.6}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 20.0, :price => 0.6}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.6} } })

category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 10.0, :price => 1.6}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 20.0, :price => 0.6}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.6} } })

#Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })

#Own and home regions, sms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 4.5} } })


#Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, mms, Outcoming, to_all_country_regions
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.6} } })

category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.6} } })

#Own regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',  
      :filtr => {:own_and_home_regions => {:in => [@tc.tarif_region_id] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 3.0} } })

#Home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',
    :filtr => {:own_and_home_regions => {:in => @tc.tarif_home_region_ids }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice,  
      :formula => {:params => {:max_sum_volume => 30.0, :price => 1.6}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 0.6} } })  


#Tarif option 'Везде Москва — в Центральном регионе'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny, :formula => {:params => {:price => 3.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_region
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_own_and_home_regions => {:in => [@tc.tarif_region_id] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
    :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 2.6, :price_1 => 1.6} } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_home_region
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_own_and_home_regions => {:in => [@tc.tarif_region_id] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
    :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 1.6, :price_1 => 0.6} } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 6.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 12.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

  
#Central regions RF except for Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_country_regions/sms_in', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_all_country_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 10.0, :price => 1.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region]  )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 20.0, :price => 0.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region]  )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, 
    :formula => {:params => {:price => 1.6} } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )

category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 10.0, :price => 1.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region]  )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 20.0, :price => 0.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region]  )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, 
    :formula => {:params => {:price => 1.6} } }, :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )

#Central regions RF except for Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 4.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_country_regions/mms_in', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to_all_country_regions
category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 4.6} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 4.6} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Tarif option 'Будь как дома'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 15.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_region
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_own_and_home_regions => {:in => [@tc.tarif_region_id] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
    :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 2.6, :price_1 => 1.6} } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_home_region
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_own_and_home_regions => {:in => @tc.tarif_home_region_ids }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
    :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 1.6, :price_1 => 0.6} } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  


#All Russia except for Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 6.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 12.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

  
#All Russia except for Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_country_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_all_country_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 10.0, :price => 1.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home]  )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 20.0, :price => 0.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home]  )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, 
    :formula => {:params => {:price => 1.6} } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )

category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 10.0, :price => 1.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home]  )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice,  
      :formula => {:params => {:max_count_volume => 20.0, :price => 0.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home]  )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, 
    :formula => {:params => {:price => 1.6} } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )

#All Russia except for Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 4.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice,  
    :formula => {:params => {:max_sum_volume => 30.0, :price => 1.6}, :window_over => 'day' } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, 
    :formula => {:params => {:price => 0.6} } }, :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  



@tc.add_tarif_class_categories

