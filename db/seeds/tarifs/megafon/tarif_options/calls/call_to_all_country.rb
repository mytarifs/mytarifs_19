@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_call_to_all_country, :name => 'Звони во все страны', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/far_calls/all_countries.html#feature',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => [_mgf_be_as_home]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )



#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 60.0} } })  

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_1
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_1, :name => 'Мегафон, опция Звони во все страны - 1 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_3_5
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_3_5, :name => 'Мегафон, опция Звони во все страны - 3,5 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.5} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_4
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_4, :name => 'Мегафон, опция Звони во все страны - 1 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 4.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_4_5
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_4_5, :name => 'Мегафон, опция Звони во все страны - 4,5 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 4.5} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_5
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_5, :name => 'Мегафон, опция Звони во все страны - 5 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_6
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_6, :name => 'Мегафон, опция Звони во все страны - 6 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 6.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_7
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_7, :name => 'Мегафон, опция Звони во все страны - 7 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_8
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_8, :name => 'Мегафон, опция Звони во все страны - 8 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_9, :name => 'Мегафон, опция Звони во все страны - 9 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_10
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_10, :name => 'Мегафон, опция Звони во все страны - 10 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_11
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_11, :name => 'Мегафон, опция Звони во все страны - 11 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 11.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_12
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_12, :name => 'Мегафон, опция Звони во все страны - 12 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 12.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_13
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_13, :name => 'Мегафон, опция Звони во все страны - 13 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_14
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_14, :name => 'Мегафон, опция Звони во все страны - 14 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 14.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_15
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_15, :name => 'Мегафон, опция Звони во все страны - 15 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_16
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_16, :name => 'Мегафон, опция Звони во все страны - 16 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 16.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_17
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_17, :name => 'Мегафон, опция Звони во все страны - 17 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_18
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_18, :name => 'Мегафон, опция Звони во все страны - 18 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 18.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_19
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_19, :name => 'Мегафон, опция Звони во все страны - 19 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_20
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_20, :name => 'Мегафон, опция Звони во все страны - 20 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_23
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_23, :name => 'Мегафон, опция Звони во все страны - 23 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 23.0} } })

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_30
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_30, :name => 'Мегафон, опция Звони во все страны - 30 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } })

#Tarif option 'Будь как дома'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 15.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_1
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_1, :name => 'Мегафон, опция Звони во все страны - 1 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_3_5
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_3_5, :name => 'Мегафон, опция Звони во все страны - 3,5 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_4
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_4, :name => 'Мегафон, опция Звони во все страны - 4 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 4.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_4_5
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_4_5, :name => 'Мегафон, опция Звони во все страны - 4,5 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 4.5} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_5
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_5, :name => 'Мегафон, опция Звони во все страны - 5 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_6
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_6, :name => 'Мегафон, опция Звони во все страны - 6 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 6.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_7
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_7, :name => 'Мегафон, опция Звони во все страны - 7 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_8
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_8, :name => 'Мегафон, опция Звони во все страны - 8 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_9
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_9, :name => 'Мегафон, опция Звони во все страны - 9 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_10
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_10, :name => 'Мегафон, опция Звони во все страны - 10 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_11
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_11, :name => 'Мегафон, опция Звони во все страны - 11 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 11.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_12
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_12, :name => 'Мегафон, опция Звони во все страны - 12 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 12.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_13
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_13, :name => 'Мегафон, опция Звони во все страны - 13 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_14
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_14, :name => 'Мегафон, опция Звони во все страны - 14 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 14.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_15
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_15, :name => 'Мегафон, опция Звони во все страны - 15 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_16
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_16, :name => 'Мегафон, опция Звони во все страны - 16 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 16.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_17
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_17, :name => 'Мегафон, опция Звони во все страны - 17 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_18
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_18, :name => 'Мегафон, опция Звони во все страны - 18 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 18.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_19
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_19, :name => 'Мегафон, опция Звони во все страны - 19 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_20
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_20, :name => 'Мегафон, опция Звони во все страны - 20 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_23
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_23, :name => 'Мегафон, опция Звони во все страны - 23 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 23.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_30
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mgf::Call_to_all_country_30, :name => 'Мегафон, опция Звони во все страны - 30 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  


@tc.add_tarif_class_categories

#Опция «Звони во все страны» действует на исходящие звонки на любые мобильные и городские номера других стран.
#Опция доступна на всех тарифах, на которых предоставляется услуга международной связи.
#Внимание: Опцию «Звони во все страны» невозможно подключить, если абонент пользуется скидкой «МегаФон-MLT». 
#Опция действует на территории Московского региона.
