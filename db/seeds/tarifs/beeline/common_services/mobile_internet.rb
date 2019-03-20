#TODO Добавить расширенный международный роуминг (новую категорию стран)
#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_mobile_internet, :name => 'Мобильный интернет', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://beeline.ru',
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


#Own and home regions, Internet
category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.95} } })  

#Own country, Internet
category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.95} } })  


@tc.add_tarif_class_categories

 