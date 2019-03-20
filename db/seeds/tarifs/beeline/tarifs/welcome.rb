@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_welcome, :name => 'Добро пожаловать', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {
    :http => 'http://moskva.beeline.ru/customers/products/mobile/tariffs/details/dobro-pozhalovat/',
    :buy_http => 'http://moskva.beeline.ru/shop/basket?shopProductId=112596',
    :phone_number_type => ["Федеральный"],
    :payment_type => "Предоплатная",
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )
  
#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })

  
#Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.7} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_regions
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.7} } })

#Own and home regions, Calls, Outcoming, to_own_country
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_1, :name => 'Билайн, услуги по тарифу Добро пожаловать, Таджикистан' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })
#  @tc.add_one_service_category_tarif_class(category, {}, 
#  {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::ThreeStepPriceDurationMinute, 
#    :formula => {:params => {:duration_minute_1 => 1.0, :duration_minute_2 => 20.0, :price_0 => 8.0, :price_1 => 1.0, :price_2 => 8.0} } } )

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_1, :name => 'Билайн, услуги по тарифу Добро пожаловать, Таджикистан' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 (Украина, Армения), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_2, :name => 'Билайн, услуги по тарифу Добро пожаловать, Армения' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 Украина, (Армения), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_2, :name => 'Билайн, услуги по тарифу Добро пожаловать, Армения' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Казахстан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_3, :name => 'Билайн, услуги по тарифу Добро пожаловать, Казахстан, Украина' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Украина, Казахстан), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_3, :name => 'Билайн, услуги по тарифу Добро пожаловать, Казахстан, Украина' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Узбекистан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_4, :name => 'Билайн, услуги по тарифу Добро пожаловать, Узбекистан' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 4.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Узбекистан), другие телефоны
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_4, :name => 'Билайн, услуги по тарифу Добро пожаловать, Узбекистан' }, :to_operators => {:not_in => Category::Operator::Const::BeelinePartnerOperators, :name => 'кроме партнеров оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 4.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_12 (Кыргызстан), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_12, :name => 'Билайн, услуги по тарифу Добро пожаловать, Кыргызстан' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_12 (Кыргызстан), телефоны Билайн
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
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_5 (Туркменистан)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_5, :name => 'Билайн, услуги по тарифу Добро пожаловать, Туркменистан' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_14 (Абхазия, Южная Осетия)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_14, :name => 'Билайн, услуги по тарифу Добро пожаловать, Абхазия, Южная Осетия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_6 (Молдова)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_6, :name => 'Билайн, услуги по тарифу Добро пожаловать, Молдова' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 11.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_7 (Беларусь, Азербайджан)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_7, :name => 'Билайн, услуги по тарифу Добро пожаловать, Беларусь, Азербайджан' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 20.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_8 (Вьетнам)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_8, :name => 'Билайн, услуги по тарифу Добро пожаловать, Вьетнам' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_9 (Китай)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_9, :name => 'Билайн, услуги по тарифу Добро пожаловать, Китай' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_10 (Индия, Южная Корея)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_10, :name => 'Билайн, услуги по тарифу Добро пожаловать, Индия, Южная Корея' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_11 (Турция)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Welcome_11, :name => 'Билайн, услуги по тарифу Добро пожаловать, Турция' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })


#Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.0} } })

#Own and home regions, sms, Outcoming, to_own_country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.95} } })

#Own and home regions, sms, Outcoming, to_bln_international_2 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_2, :name => 'Билайн, услуги СНГ, Абхазия, Грузия и Южная Осетия на прочие телефоны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.95} } })

#Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, mms, Outcoming, to_all_own_country_regions
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })


#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 12.50} } })


#Own country, mms, incoming
category = {:uniq_service_category => 'own_country_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own country, mms, Outcoming, _service_to_all_own_country_regions
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.95} } })

category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 9.95} } })

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.95} } })  



@tc.add_tarif_class_categories

