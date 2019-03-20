@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_around_world, :name => 'Вокруг света', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {
    :http => 'http://moscow.megafon.ru/tariffs/alltariffs/special/vokrug_sveta/vokrug_sveta.html',
    :phone_number_type => ["Федеральный"],
    :payment_type => "Предоплатная",
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],    
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
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

#Own and home regions, Calls, Outcoming, to_own_and_home_region
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.8} } })

#Own and home regions, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })


#Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.9} } })

#Own and home regions, sms, Outcoming, to_own country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.0} } })

#Own and home regions, sms, Outcoming, to_own country, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.55} } })

#Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })

#Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.0} } })

#Own and home regions, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.9} } })


#Around_world_1, Calls, Incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_1, :name => 'Страны Мегафона для Вокруг света 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Around_world_1, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_1, :name => 'Страны Мегафона для Вокруг света 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Around_world_1, Calls, Outcoming, to_rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_1, :name => 'Страны Мегафона для Вокруг света 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Around_world_1, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in',  
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_1, :name => 'Страны Мегафона для Вокруг света 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Around_world_1, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_1, :name => 'Страны Мегафона для Вокруг света 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 11.0} } })


#Around_world_2, Calls, Incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_2, :name => 'Страны Мегафона для Вокруг света 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Around_world_2, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_2, :name => 'Страны Мегафона для Вокруг света 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Around_world_2, Calls, Outcoming, to_rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_2, :name => 'Страны Мегафона для Вокруг света 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Around_world_2, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_2, :name => 'Страны Мегафона для Вокруг света 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Around_world_2, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_2, :name => 'Страны Мегафона для Вокруг света 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 11.0} } })


#Around_world_3, Calls, Incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_3, :name => 'Страны Мегафона для Вокруг света 3' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } })

#Around_world_3, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_3, :name => 'Страны Мегафона для Вокруг света 3' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } })

#Around_world_3, Calls, Outcoming, to_rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_3, :name => 'Страны Мегафона для Вокруг света 3' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } })

#Around_world_3, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in',  
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_3, :name => 'Страны Мегафона для Вокруг света 3' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Around_world_3, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_3, :name => 'Страны Мегафона для Вокруг света 3' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.0} } })


#Around_world_4, Calls, Incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_4, :name => 'Страны Мегафона для Вокруг света 4' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 43.0} } })

#Around_world_4, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_4, :name => 'Страны Мегафона для Вокруг света 4' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 43.0} } })

#Around_world_4, Calls, Outcoming, to_rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_4, :name => 'Страны Мегафона для Вокруг света 4' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 43.0} } })

#Around_world_4, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in',  
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_4, :name => 'Страны Мегафона для Вокруг света 4' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Around_world_4, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_4, :name => 'Страны Мегафона для Вокруг света 4' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.0} } })


#Around_world_5, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Around_world_countries_5, :name => 'Страны Мегафона для Вокруг света 5' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 19.0} } })



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

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_and_home_region
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.8} } },
  :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

 
#Central regions RF except for Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_country_regions/sms_in', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.9} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own country, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.55} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } },
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

#All Russia except for Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_and_home_region
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.8} } },
  :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

 
#All Russia except for Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_country_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.9} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_own country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_own country, to_not_own_operator
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.55} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.55} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.9} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  



@tc.add_tarif_class_categories

