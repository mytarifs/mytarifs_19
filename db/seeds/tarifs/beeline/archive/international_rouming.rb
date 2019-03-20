#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_international_rouming, :name => 'Путешествие по миру', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/roaming/puteshestviya-po-miru/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#SIC, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#SIC, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#SIC, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#SIC, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#SIC, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#SIC, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out',  
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#SIC, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#SIC, mms, outcoming
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic , :name => 'Страны СНГ Билайна'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.95} } })  


#Other countries, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 69.0} } })  

#other_countries, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 69.0} } })  

#other_countries, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 69.0} } })  

#other_countries, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#other_countries, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#other_countries, sms, outcoming 
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#other_countries, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#other_countries, mms, outcoming
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.95} } })   

 
@tc.add_tarif_class_categories

