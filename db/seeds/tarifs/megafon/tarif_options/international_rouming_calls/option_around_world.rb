#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_option_around_world, :name => 'опция Вокруг света', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/aworld.html',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :international_calls_options => [
        _mgf_all_world, _mgf_minute_packs_25_europe, _mgf_minute_packs_50_europe, _mgf_minute_packs_25_world, _mgf_minute_packs_50_world, 
        _mgf_30_minutes_all_world, _mgf_far_countries, _mgf_option_around_world, _mgf_100_minutes_europe]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 15.0} } })  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 9.0} } })


#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_1 , :name => 'Страны Мегафон 1-я группа опции вокруг мира'}}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })  

#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_1, :name => 'Страны Мегафон 1-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })  

#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_1, :name => 'Страны Мегафон 1-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })  

#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_1, :name => 'Страны Мегафон 1-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 11.0} } })  


#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_2, :name => 'Страны Мегафон 2-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } })  

#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_2, :name => 'Страны Мегафон 2-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } })  

#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_2, :name => 'Страны Мегафон 2-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.0} } })  

#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_2, :name => 'Страны Мегафон 2-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.0} } })  

 
#Китай и остальные страны, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_3, :name => 'Страны Мегафон 3-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 43.0} } })  

#Китай и остальные страны, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_3, :name => 'Страны Мегафон 3-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 43.0} } })  

#Китай и остальные страны, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_3, :name => 'Страны Мегафон 3-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 43.0} } })  

#Китай и остальные страны, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Option_around_world_3, :name => 'Страны Мегафон 3-я группа опции вокруг мира' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.0} } })  


@tc.add_tarif_class_categories

#–Для корректной работы опции, после ее подключения, необходимо выключить и включить ваше мобильное устройство.
#–Если абонент, подключивший опцию, находится в стране, где местное время отстает от московского, то скидка начнет действовать только тогда, когда местное время совпадет со временем подключения опции по Москве.
#–Стоимость услуг связи по тарифной опции не распространяется на вызовы, которые совершаются через сети спутниковой связи с помощью специального оборудования.
#–Опция «Вокруг света» доступна для подключения абонентам большинства частных и корпоративных тарифных планов «МегаФон», кроме «Вокруг света», «Интернет старт», «Командировочный», «МегаФон-Логин», «МегаФон-Логин Безлимитный» и «МегаФон-Логин Оптимальный».
#Чтобы уточнить возможность подключения опции, зайдите в Личный кабинет (Сервис-Гид) и откройте меню «Услуги и тариф», либо позвоните в Контактный центр по номеру 0500. 

