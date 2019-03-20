@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_intra_countries_services, :name => 'Звонки за границу', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://msk.tele2.ru/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )


#Own and home regions, calls, outcoming, to sic
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Теле 2, СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } })  

#Own and home regions, calls, outcoming, to Europe
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Теле 2, Европа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#Own and home regions, calls, outcoming, to USA and Canada
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_3, :name => 'Теле 2, США и Канада' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#Own and home regionsIC, calls, outcoming, to other countries
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_4, :name => 'Теле 2, Мир кроме СНГ, Европы, США и Канады' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#Own and home regions, sms, outcoming, to not Russia
  category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.5} } })  


#Own and home regions, mms, outcoming, to not Russia
  category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  

@tc.add_tarif_class_categories

