#Own country rouming
@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_own_country_rouming, :name => 'Путешествие по России', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/roaming/puteshestvia-po-rossii/',
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

#Own country, calls, incoming
  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.95} } })  
 
#Own country, calls, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.95} } })  

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.95} } })  

#Own country, Calls, Outcoming, to_bln_international_2 (на телефоны стран СНГ, Грузии, Абхазии, Южной Осетии)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_2, :name => 'Билайн, услуги СНГ, Абхазия, Грузия и Южная Осетия на прочие телефоны' }}} 
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 34.25} } })  

#Own country, Calls, Outcoming, to_bln_international_2 (услуги в страны кроме России и СНГ)
category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_13, :name => 'Билайн, услуги в страны кроме России и СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 67.75} } })  


#Own country, sms, incoming
  category = {:uniq_service_category => 'own_country_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Own country, sms, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', }
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 4.95} } })  

  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 4.95} } })  

#Own country, sms, outcoming, to not own country
  category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.95} } })  

#Own country, mms, incoming
  category = {:uniq_service_category => 'own_country_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Own country, mms, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })  

  category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })  

#Own country, mms, outcoming, to sic
  category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС' }}} 
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })  

#Own country, mms, outcoming, to europe
  category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'услуги в Европу МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })  

#Own country, mms, outcoming, to other_countries
  category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Other_countries, :name => 'услуги в прочие страны МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })  

#Own country, Internet 
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.95} } })



@tc.add_tarif_class_categories

