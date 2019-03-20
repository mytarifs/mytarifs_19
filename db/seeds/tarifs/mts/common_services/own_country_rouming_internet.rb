#Интернет во внутресетевом роуминге 
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_own_country_rouming_internet, :name => 'Интернет во внутресетевом роуминге', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/inet_roaming/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )


#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.9} } })

@tc.add_tarif_class_categories
