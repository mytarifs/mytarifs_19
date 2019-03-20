@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_country_rouming, :name => 'Путешествия по России', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://msk.tele2.ru/roaming/russia/',
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

#Own country region group 1, calls, incoming
  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 1, calls, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 1, calls, outcoming, to sic
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }, :to_abroad_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'МТС, страны СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#Own country region group 1, calls, outcoming, to Europe
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }, :to_abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'МТС, страны Европы' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#Own country region group 1, calls, outcoming, to other countries
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }, :to_abroad_countries => {:in => Category::Country::Mts::Other_countries, :name => 'МТС, остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#Own country region group 1, sms, incoming
  category = {:uniq_service_category => 'own_country_regions/sms_in', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Own country region group 1, sms, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions',  
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

#Own country region group 1, sms, outcoming, to not own country
  category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1, :name => 'Теле 2, Регионы 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.5} } })  



#Own country region group 2, calls, incoming
  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 2, calls, outcoming, to all own country regions, to own operator
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_operators => {:in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_operators => {:in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 2, calls, outcoming, to all own country regions, to not own operator
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_operators => {:not_in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_operators => {:not_in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 2, calls, outcoming, to sic
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Теле 2, СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#Own country region group 2, calls, outcoming, to Europe
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Теле 2, Европа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#Own country region group 2, calls, outcoming, to USA and Canada
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_3, :name => 'Теле 2, США и Канада' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#Own country region group 2, calls, outcoming, to other countries
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_4, :name => 'Теле 2, Мир кроме СНГ, Европы, США и Канады' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#Own country region group 2, sms, incoming
  category = {:uniq_service_category => 'own_country_regions/sms_in', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Own country region group 2, sms, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

#Own country region group 2, sms, outcoming, to not own country
  category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2, :name => 'Теле 2, Регионы 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.5} } })  

@tc.add_tarif_class_categories

