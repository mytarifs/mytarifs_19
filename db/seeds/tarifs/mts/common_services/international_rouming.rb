#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_international_rouming, :name => 'Международный роуминг', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/howtoget/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#All world, sms, incoming
  category = {:uniq_service_category => 'abroad_countries/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#All world, sms, outcoming
  category = {:uniq_service_category => 'abroad_countries/sms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#_mts_sic_12_for_40_internet, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_12_for_40_internet, :name => 'Страны МТС СНГ для роуминга, интернет за 12 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 300.0} } })  

#_mts_sic_14_for_40_internet, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_14_for_40_internet, :name => 'Страны МТС СНГ для роуминга, интернет за 14 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 350.0} } })  

#_mts_sic_30_for_40_internet, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_30_for_40_internet, :name => 'Страны МТС СНГ для роуминга, интернет за 40 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })  

#Europe, Internet 
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'Страны Европы МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })  

#Other countries, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries, :name => 'Прочие страны МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })  



#_mts_sic_abkhazia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_abkhazia, :name => 'Страны МТС СНГ для роуминга, Абхазия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_mts_sic_abkhazia, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_abkhazia, :name => 'Страны МТС СНГ для роуминга, Абхазия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_mts_sic_abkhazia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_abkhazia, :name => 'Страны МТС СНГ для роуминга, Абхазия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_mts_sic_abkhazia, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_abkhazia, :name => 'Страны МТС СНГ для роуминга, Абхазия' }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })

#_mts_sic_abkhazia, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries',  
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_abkhazia, :name => 'Страны МТС СНГ для роуминга, Абхазия' }, :to_other_countries => {:not_in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


#_mts_sic_south_ossetia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in',  
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_south_ossetia }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_south_ossetia, :name => 'Страны МТС СНГ для роуминга, Южная Осетия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_south_ossetia, :name => 'Страны МТС СНГ для роуминга, Южная Осетия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries',  
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_south_ossetia , :name => 'Страны МТС СНГ для роуминга, Южная Осетия'}, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 38.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_south_ossetia, :name => 'Страны МТС СНГ для роуминга, Южная Осетия' }, :to_other_countries => {:not_in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_south_ossetia, :name => 'Страны МТС СНГ для роуминга, Южная Осетия' }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 38.0} } })  


#_mts_sic_45_to_russia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_45_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 45 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_mts_sic_65_to_russia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_65_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_mts_sic_75_to_russia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in',  
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_75_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 75 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_mts_sic_85_to_russia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_85_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 85 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_mts_sic_115_to_russia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_115_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 115 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  


#_mts_sic_45_to_russia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_45_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 45 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_mts_sic_65_to_russia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_65_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_mts_sic_75_to_russia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_75_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 75 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_mts_sic_85_to_russia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_85_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 85 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_mts_sic_115_to_russia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_115_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 115 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  



#_mts_sic_45_to_russia, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_45_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 45 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_mts_sic_65_to_russia, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_65_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_mts_sic_75_to_russia, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_75_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 75 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_mts_sic_85_to_russia, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_85_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 85 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_mts_sic_115_to_russia, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_115_to_russia, :name => 'Страны МТС СНГ для роуминга, звонки в Россию за 115 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_mts_sic_109_to_sic, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_109_to_sic, :name => 'Страны МТС СНГ для роуминга, звонки в СНГ за 109 руб'}, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 109.0} } })  

#_mts_sic_135_to_other_countries, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_135_to_other_countries, :name => 'Страны МТС СНГ для роуминга, звонки в другие страны за 135 руб' }, :to_other_countries => {:not_in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_25_25_25_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_25_25_25_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 25 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#_sc_rouming_mts_europe_countries_25_25_25_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_25_25_25_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 25 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#_sc_rouming_mts_europe_countries_25_25_25_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_25_25_25_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 25 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#_sc_rouming_mts_europe_countries_25_25_25_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_25_25_25_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 25 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_30_30_30_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_30_30_30_135 , :name => 'Страны МТС Европа для роуминга, звонки в Россию за 30 руб'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } })  

#_sc_rouming_mts_europe_countries_30_30_30_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_30_30_30_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 30 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } })  

#_sc_rouming_mts_europe_countries_30_30_30_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_30_30_30_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 30 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } })  

#_sc_rouming_mts_europe_countries_30_30_30_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_30_30_30_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 30 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 3,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_45_45_45_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_45_45_45_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 45 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_sc_rouming_mts_europe_countries_45_45_45_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_45_45_45_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 45 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_sc_rouming_mts_europe_countries_45_45_45_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_45_45_45_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 45 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_sc_rouming_mts_europe_countries_45_45_45_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_45_45_45_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 45 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 4,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_50_50_50_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_50_50_50_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 50 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 50.0} } })  

#_sc_rouming_mts_europe_countries_50_50_50_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_50_50_50_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 50 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 50.0} } })  

#_sc_rouming_mts_europe_countries_50_50_50_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_50_50_50_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 50 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 50.0} } })  

#_sc_rouming_mts_europe_countries_50_50_50_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_50_50_50_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 50 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 5,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_60_60_60_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_60_60_60_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_europe_countries_60_60_60_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_60_60_60_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_europe_countries_60_60_60_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_60_60_60_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_europe_countries_60_60_60_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_60_60_60_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 6,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_65_65_65_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_65_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_65_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_65_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_65_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_65_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_65_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_65_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 7,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_65_65_75_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_75_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 75 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_75_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_75_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 75 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_75_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_75_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 75 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_sc_rouming_mts_europe_countries_65_65_75_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_65_65_75_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 75 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 8,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_99_99_99_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_99_99_99_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_europe_countries_99_99_99_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_99_99_99_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_europe_countries_99_99_99_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_99_99_99_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_europe_countries_99_99_99_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_99_99_99_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 9,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_115_115_115_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_115_115_115_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 115 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_sc_rouming_mts_europe_countries_115_115_115_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_115_115_115_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 115 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_sc_rouming_mts_europe_countries_115_115_115_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_115_115_115_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 115 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_sc_rouming_mts_europe_countries_115_115_115_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_115_115_115_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 115 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 10,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_155_155_155_155, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_155_155_155_155, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_europe_countries_155_155_155_155, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_155_155_155_155, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_europe_countries_155_155_155_155, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_155_155_155_155, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_europe_countries_155_155_155_155, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_155_155_155_155, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


#_sc_rouming_mts_europe_countries_85_85_85_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_85_85_85_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 85 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_sc_rouming_mts_europe_countries_85_85_85_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_85_85_85_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 85 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_sc_rouming_mts_europe_countries_85_85_85_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_85_85_85_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 85 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_sc_rouming_mts_europe_countries_85_85_85_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries_85_85_85_135, :name => 'Страны МТС Европа для роуминга, звонки в Россию за 85 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 11,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_other_countries_60_60_60_60, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_60_60_60_60, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_other_countries_60_60_60_60, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_60_60_60_60, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_other_countries_60_60_60_60, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_60_60_60_60, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_other_countries_60_60_60_60, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_60_60_60_60, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 60 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  


#_sc_rouming_mts_other_countries_65_65_65_135, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_65_65_65_135, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_other_countries_65_65_65_135, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_65_65_65_135, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_other_countries_65_65_65_135, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_65_65_65_135, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_other_countries_65_65_65_135, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_65_65_65_135, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 65 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 12,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_other_countries_99_99_99_155, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_99_99_99_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_other_countries_99_99_99_155, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_99_99_99_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_other_countries_99_99_99_155, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_99_99_99_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_other_countries_99_99_99_155, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_99_99_99_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 99 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


#_sc_rouming_mts_other_countries_200_200_200_200, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_200_200_200_200, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 200 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#_sc_rouming_mts_other_countries_200_200_200_200, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_200_200_200_200, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 200 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#_sc_rouming_mts_other_countries_200_200_200_200, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_200_200_200_200, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 200 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#_sc_rouming_mts_other_countries_200_200_200_200, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_200_200_200_200, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 200 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  


#_sc_rouming_mts_other_countries_250_250_250_250, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_250_250_250_250, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 250 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  

#_sc_rouming_mts_other_countries_250_250_250_250, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_250_250_250_250, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 250 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  

#_sc_rouming_mts_other_countries_250_250_250_250, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_250_250_250_250, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 250 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  

#_sc_rouming_mts_other_countries_250_250_250_250, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_250_250_250_250, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 250 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  


#_sc_rouming_mts_other_countries_155_155_155_155, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_155_155_155_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_other_countries_155_155_155_155, calls, outcoming, to Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_155_155_155_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_other_countries_155_155_155_155, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_155_155_155_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_other_countries_155_155_155_155, calls, outcoming, to not rouming country and not Russia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Other_countries_155_155_155_155, :name => 'Страны МТС Другие страны для роуминга, звонки в Россию за 155 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


@tc.add_tarif_class_categories

#Тарификация поминутная, с округлением до целых минут в большую сторону

#В Ямало-Ненецком, Ханты-Мансийском АО, Пермском крае, Волгоградской и Пензенской областях кроме сети МТС, действуют сети операторов-партнеров.
#При выборе их сетей действуют следующие тарифы:
#– Все входящие вызовы и исходящие на номера России – 17 руб./мин.
#– Исходящие вызовы в другие страны СНГ – 38 руб./мин.
#– Исходящие вызовы в прочие страны – 129 руб./мин.
#– Исходящие SMS – 4,5 руб.
#– Входящие SMS – 0 руб.
#– GPRS – 8,6 руб. за 40 кб
#Скидки и опции в сетях других операторов не действуют.

# Доступ к услугам контент-провайдеров в роуминге посредством SMS на короткие номера, оплачивается по тарифу, действующему в "домашнем" регионе, плюс 3.95 руб.