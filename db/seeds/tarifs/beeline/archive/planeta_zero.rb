@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_planeta_zero, :name => 'Планета Ноль', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {
    :http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/planeta-nol/',
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
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 25.0} } })  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} }})

#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {},  
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed,  
      :formula => {:params => {:max_duration_minute => 20.0, :price => 60.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration,:formula => {:params => {:price => 10.0} } })

#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), calls, outcoming, 
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } })  

#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.0} } })  


#bln_my_planet_groups_2 (остальные страны), calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {},  
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed,  
      :formula => {:params => {:max_duration_minute => 20.0, :price => 100.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })

#bln_my_planet_groups_2 (остальные страны), calls, outcoming, 
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#bln_my_planet_groups_2 (остальные страны), sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::My_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.0} } })  





@tc.add_tarif_class_categories


#Услуга доступна к подключению физическим и юридическим лицам предоплатной системы расчетов во всех регионах России.
#Услуга действует до самостоятельного отключения абонентом.
#Услуга действует во всех странах международного роуминга «Билайн».
#Цена звонка - за минуту разговора, тарификация поминутная. Звонки в международном роуминге тарифицируются с первой секунды. Стоимость входящих вызовов указана за каждый разговор.
#При подключении услуги «Планета Ноль» услуга «Моя планета» не предоставляется и будет автоматически отключена, если была подключена ранее. 
#Услуга недоступна на тарифном плане «Мир Билайн 2011».
#Цены указаны с учетом НДС