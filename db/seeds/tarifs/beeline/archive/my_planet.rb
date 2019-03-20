@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_my_planet, :name => 'Моя планета', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moya-planeta/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:international_calls => [_bln_my_planet, _bln_planeta_zero]}, 
    :general_priority => _gp_tarif_option_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#Подключение
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 25.0} } })  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })


#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), calls, outcoming, 
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.0} } })  


#bln_my_planet_groups_2 (остальные страны), calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#bln_my_planet_groups_2 (остальные страны), calls, outcoming, 
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#bln_my_planet_groups_2 (остальные страны), sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.0} } })  


@tc.add_tarif_class_categories


#Пожалуйста, подключайте роуминговые опции заранее. Если вы абонент постоплатной системы расчётов и подключили опцию, находясь в стране, где местное время отстаёт от московского, опция начнет действовать, когда местное время в стране пребывания совпадет с московским.
#Услуга доступна к подключению физическим и юридическим лицам предоплатной и постоплатной системы расчетов во всех регионах России.
#Услуга действует до момента самостоятельного отключения абонентом.
#Цена звонка - за минуту разговора, тарификация поминутная. Звонки в международном роуминге тарифицируются с первой секунды. Исходящие вызовы на номера спутниковых систем связи тарифицируются по стандартным тарифам.
#При подключении услуги «Моя Планета», услуги «Планета Ноль» и «Мультипасс» не предоставляются и будут автоматически отключены, если были подключены ранее.
#Услуга недоступна на всех тарифных планах для USB-модемов и планшетов.
#Цена указаны с учетом НДС.
