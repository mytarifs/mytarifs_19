@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_intra_countries_services, :name => 'Международные вызовы', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://megafon.ru',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )
  

#Own and home regions, Calls, Outcoming, to_mgf_country_group_1 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_1, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })

#Own and home regions, Calls, Outcoming, to_mgf_country_group_2 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_2, :name => 'Мегафон, услуги в Европу (вкл. Турцию, Израиль), США, Канада' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 55.0} } })

#Own and home regions, Calls, Outcoming, to_mgf_country_group_3 (Австралия и Океания)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_3, :name => 'Мегафон, услуги в Австралию и Океанию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })

#Own and home regions, Calls, Outcoming, to_mgf_country_group_4 (Азия)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_4, :name => 'Мегафон, услуги в Азию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })

#Own and home regions, Calls, Outcoming, to_mgf_country_group_5 (Остальные страны)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_5, :name => 'Мегафон, услуги в остальные  страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })


#Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })

#Own and home regions, sms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })


#Own and home regions, mms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 10.0} } })

#Own and home regions, mms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 20.0} } })


#Own country, Calls, Outcoming, to_mgf_country_group_1 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_1, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })

#Own country, Calls, Outcoming, to_mgf_country_group_2 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_2, :name => 'Мегафон, услуги в Европу (вкл. Турцию, Израиль), США, Канада' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 55.0} } })

#Own country, Calls, Outcoming, to_mgf_country_group_3 (Австралия и Океания)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_3, :name => 'Мегафон, услуги в Австралию и Океанию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })

#Own country, Calls, Outcoming, to_mgf_country_group_4 (Азия)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_4, :name => 'Мегафон, услуги в Азию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })

#Own country, Calls, Outcoming, to_mgf_country_group_5 (Остальные страны)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Country_group_5, :name => 'Мегафон, услуги в остальные  страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })


#Own country, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })

#Own country, sms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })


#Own country, mms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 10.0} } })

#Own country, mms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 20.0} } })




#Tarif option 'Везде Москва — в Центральном регионе'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny, :formula => {:params => {:price => 3.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_1 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Country_group_1, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_2 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Country_group_2, :name => 'Мегафон, услуги в Европу (вкл. Турцию, Израиль), США, Канада' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 55.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_3 (Австралия и Океания)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Country_group_3, :name => 'Мегафон, услуги в Австралию и Океанию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_4 (Азия)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Country_group_4, :name => 'Мегафон, услуги в Азию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_5 (Остальные страны)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Country_group_5, :name => 'Мегафон, услуги в остальные  страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, mms, Outcoming, to sms_sic_plus_countries
category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 13.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, sms_other_countries
category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }, :to_abroad_countries => {:in => Category::Country::Mgf::Sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 23.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  




@tc.add_tarif_class_categories

