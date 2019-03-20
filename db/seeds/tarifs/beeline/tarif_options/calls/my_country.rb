@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_my_country, :name => 'Моя страна', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moya-strana/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 25.0} } })  

#Периодическая плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })


#Own country, calls, incoming
  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })  

#Own country, calls, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })  

  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', }
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })  

#Own country, sms, outcoming, to all own country regions, to all operators
  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', }
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.0} } })  

  category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.0} } })  


@tc.add_tarif_class_categories



#Услуга доступна к подключению физическим и юридическим лицам предоплатной и постоплатной системы расчетов во всех регионах России.
#Услуга действует до момента самостоятельного отключения абонентом.
#Цена звонка - за минуту разговора, тарификация поминутная. Звонки тарифицируются с первой секунды. 
#Исходящие вызовы на номера спутниковых систем связи тарифицируются по стандартным тарифам.
#Услуга недоступна на ряде тарифных планов.
#Услуга недоступна на всех тарифных планах для USB-модемов и планшетов.
#Цена указаны с учетом НДС.
