@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_welcome_to_all_tarifs, :name => 'Добро пожаловать на ВСЕ', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/dobro-pozhalovat-na-vse/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:international_calls => [_bln_my_abroad_countries, _bln_my_calls_to_other_countries, _bln_welcome_to_all_tarifs]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_all_for_300, _bln_all_for_500, _bln_all_for_800, _bln_all_for_1200, _bln_all_for_1800, _bln_total_all_post],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 0.0} } })  

#Периодическая плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_1, :name => 'Билайн, услуги по тарифу Добро пожаловать, Таджикистан' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
     :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 1.5, :price_1 => 2.5} } } )

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_1, :name => 'Билайн, услуги по тарифу Добро пожаловать, Таджикистан' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 (Армения), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_2, :name => 'Билайн, услуги по тарифу Добро пожаловать, Армения' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 (Армения), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_2, :name => 'Билайн, услуги по тарифу Добро пожаловать, Армения' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Украина, Казахстан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_3, :name => 'Билайн, услуги по тарифу Добро пожаловать, Казахстан, Украина' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Украина, Казахстан), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_3, :name => 'Билайн, услуги по тарифу Добро пожаловать, Казахстан, Украина' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Узбекистан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_4, :name => 'Билайн, услуги по тарифу Добро пожаловать, Узбекистан' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.9} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Узбекистан), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_4, :name => 'Билайн, услуги по тарифу Добро пожаловать, Узбекистан' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.9} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_12 (Кыргызстан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_12, :name => 'Билайн, услуги по тарифу Добро пожаловать, Кыргызстан' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_12 (Кыргызстан), телефоны не Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_12, :name => 'Билайн, услуги по тарифу Добро пожаловать, Кыргызстан' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 11.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_13 (Грузия), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_13, :name => 'Билайн, услуги по тарифу Добро пожаловать, Грузия' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_13 (Грузия), телефоны не Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_13, :name => 'Билайн, услуги по тарифу Добро пожаловать, Грузия' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_5 (Туркменистан)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_5, :name => 'Билайн, услуги по тарифу Добро пожаловать, Туркменистан' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_6 (Молдова)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_6, :name => 'Билайн, услуги по тарифу Добро пожаловать, Молдова' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } }) 

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_7 (Беларусь, Азербайджан)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_7, :name => 'Билайн, услуги по тарифу Добро пожаловать, Беларусь, Азербайджан' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_8 (Вьетнам)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_8, :name => 'Билайн, услуги по тарифу Добро пожаловать, Вьетнам' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_9 (Китай)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_9, :name => 'Билайн, услуги по тарифу Добро пожаловать, Китай' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } }) 



@tc.add_tarif_class_categories

