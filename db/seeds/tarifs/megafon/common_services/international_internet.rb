#TODO Добавить расширенный международный роуминг (новую категорию стран)
#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_international_internet, :name => 'Путешествие по миру, интернет', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Popular countries, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Popular_countries_international_internet, :name => 'Страны Мегафона, Популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseDay,  
      :formula => {:params => {:max_sum_volume => 50.0, :price => 350.0} } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 7.0} } })  


#sic, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_internet, :name => 'Страны Мегафона, СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseDay,  
      :formula => {:params => {:max_sum_volume => 65.0, :price => 260.0} } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 4.0} } })  

#Europe, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_internet, :name => 'Страны Мегафона, Европы' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseDay,  
      :formula => {:params => {:max_sum_volume => 65.0, :price => 260.0} } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 4.0} } })  


#Other countries, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_internet, :name => 'Страны Мегафона, остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseDay,  
      :formula => {:params => {:max_sum_volume => 10.0, :price => 400.0} } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 40.0} } })  



@tc.add_tarif_class_categories

