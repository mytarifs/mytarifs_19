@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_my_calls_to_other_countries, :name => 'Мои звонки в другие страны', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moi-zvonki-v-drugie-strany/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:international_calls => [_bln_my_abroad_countries, _bln_my_calls_to_other_countries, _bln_welcome_to_all_tarifs]}, 
    :general_priority => _gp_tarif_option_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_bln_all_for_300, _bln_all_for_1500, _bln_all_for_2700, _bln_all_for_600_post, _bln_all_for_1500_post, _bln_all_for_2700_post], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 25.0} } })  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 30.0} } })

 
#Own and home regions, Calls, Outcoming, to_bln_international_1 (СНГ (Абхазия, Армения, Грузия, Южная Осетия, Казахстан, Киргизия, Таджикистан, Туркменистан, Узбекистан, Украина) )
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Calls_to_other_countries_1, :name => 'Страны Билайна для "Мои звонки в другие страны", СНГ (Абхазия, Армения, Грузия, Южная Осетия, Казахстан, Киргизия, Таджикистан, Туркменистан, Узбекистан, Украина)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })

#Own and home regions, Calls, Outcoming, to_bln_international_2 (Европа, США, Канада, Белоруссия, Азербайджан, Молдова, Турция, Китай)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Calls_to_other_countries_2, :name => 'Страны Билайна для "Мои звонки в другие страны", Европа, США, Канада, Белоруссия, Азербайджан, Молдова, Турция, Китай' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })

#Own and home regions, Calls, Outcoming, to_bln_international_3 (прочие страны)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::Calls_to_other_countries_3, :name => 'Страны Билайна для "Мои звонки в другие страны", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })

#Own and home regions, sms, Outcoming, to_not_own_country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.5} } })




@tc.add_tarif_class_categories



#Опции «Любимая страна», «Моя Молдова» на тарифе «Мир Билайн»:
#• отключаются автоматически, если вы подключаете опцию «Мои звонки в другие страны» по номеру 06742, в Личном кабинете или на сайте.
#Опция доступна всем абонентам предоплатной системы расчётов, на всех тарифных планах, за исключением тарифов «Безлимитный ин-т для планшетов», «Всё включено M», «Всё включено XL», «Всё включено.Максимум», «Всё за 1200», «Всё за 2700», «Всё за 300», «Всё за 600» 
#Опция доступна всем абонентам постоплатной системы расчётов, на всех тарифных планах, за исключением тарифов «Всё за 600», «Всё за 1200», «Всё за 1450», «Всё за 2700», «Всё за 2050», «Всё за 3550».  
