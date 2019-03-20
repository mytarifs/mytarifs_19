#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_international_rouming_internet_post, :name => 'Путешествие по миру, интернет (постоплатный)', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/roaming/puteshestviya-po-miru/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1500_post, _bln_all_for_2700_post, _bln_total_all_post],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )
 

#SIC, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Sic, :name => 'Страны СНГ Билайна' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 40.0, :price => 200.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 5.0} } })  

#Other countries, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::Other_world, :name => 'Страны мира Билайна (кроме СНГ и России)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 40.0, :price => 200.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 5.0} } })  


@tc.add_tarif_class_categories 

