#Любимая страна
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_love_country, :name => 'Любимая страна', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/calls_across_russia/discounts/favorite_country/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {:love_country => [_mts_love_country, _mts_love_country_all_world]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart_bezlimitishe, _mts_your_country], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 70.0} } })

#Own and home regions, Calls, Outcoming, to_russia, to own operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {},  {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, Calls, Outcoming, to_russia, to not own operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {},  {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.5} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_4_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_4_9, :name => 'услуги в 1-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 4.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_5_5
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_5_5, :name => 'услуги в 2-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.5} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_5_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_5_9, :name => 'услуги в 3-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_6_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_6_9, :name => 'услуги в 4-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 6.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_7_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_7_9, :name => 'услуги в 5-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_8_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_8_9, :name => 'услуги в 6-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_9_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_9_9, :name => 'услуги в 7-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_11_5
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_11_5, :name => 'услуги в 8-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 11.5} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_12_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_12_9, :name => 'услуги в 9-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 12.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_14_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_14_9, :name => 'услуги в 10-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 14.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_19_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_19_9, :name => 'услуги в 11-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_29_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_29_9, :name => 'услуги в 12-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 29.9} } })

#Own and home regions, Calls, Outcoming, to_mts_love_countries_49_9
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Love_countries_49_9, :name => 'услуги в 13-ю любимую группу стран МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.9} } })

@tc.add_tarif_class_categories

#TODO поставить ограничение на возможность выбора только одной страны из каждого региона (Россия, СНГ, Европа, Азия, Прочие страны)
#TODO узнать что такое "Страны МТС"
#Страны МТС          3.9   *111*101*001#
#_russia Россия На МТС       2.5   *111*101*7#
#_russia Россия остальные    3.5   *111*101*7#

#Тарифная опция «Любимая страна» позволяет звонить на все телефоны России и в любую выбранную страну мира по низкой цене.
#Ежемесячная плата за опцию «Любимая страна» — 70 руб.
#Тарифная опция «Любимая страна. Весь Мир» дает возможность звонить по низким цены сразу во все страны мира. Стоимость всех звонков соответствует тарифам «Любимой страны».
#Ежемесячная плата за опцию «Любимая страна. Весь Мир» — 290 руб.
 
#Как подключить
#Для подключения опции «Любимая страна» выберите из предлагаемого списка страну, которую хотите подключить, и наберите на своем телефоне соответствующую команду.

#На один абонентский номер Вы можете одновременно подключить до 5 любимых стран, если они находятся в разных географических зонах — Россия, СНГ  , Европа  , Азия  , Прочие Страны.

#Есть два способа отключения опции «Любимая страна»
#наберите на своем мобильном телефоне *111*100*<географический код страны>#;
#воспользуйтесь Интернет-Помощником.

#Есть два способа подключения / отключения тарифной опции «Любимая страна. Весь Мир»:
#наберите на своем мобильном телефоне: для подключения – *111*101#;
#для отключения – *111*100#;
#воспользуйтесь Интернет-Помощником.

#Сколько стоит
#Ежемесячная плата за использование тарифной опции:
#«Любимая страна» — 70 руб.;
#«Любимая страна. Весь Мир» — 290 руб.

#Плата за первый месяц пользования опцией списывается сразу при подключении. Со следующего месяца и далее до самостоятельного отключения опции взимается ежемесячная плата в день, 
#соответствующий дате подключения.
#Оплата в указанном размере производится независимо от местонахождения абонента на протяжении всего периода действия опции.
#При подключении опции «Любимая страна» тарификация исходящих голосовых вызовов на любые телефоны выбранной страны производится в соответствии с указанными специальными тарифами. 
#Специальный тариф действует на все номера операторов подвижной и фиксированной связи выбранной страны.

#Кто может подключить
#Тарифные опции «Любимая страна» и «Любимая страна. Весь Мир» доступны для подключения на всех некорпоративных тарифных планах.

#Условия использования
#Опции «Любимая страна» и «Любимая страна. Весь Мир» являются взаимоисключающими между собой.
#При смене тарифного плана действие опций сохраняется. Срок действия предложения не ограничен.
#Если на вашем тарифном плане были подключены другие тарифные опции, дающие скидку на международные звонки, 
#то при подключении любой страны мира (кроме России) в качестве «любимой» действие этих скидок прекращается.

#Подробная информация
#Внимание! Тарифные опции для абонентов г. Москва и Московской области действительны при нахождении в г. Москва и Московской области при подключенной услуге 
#«Международный доступ» или «Легкий роуминг и международный доступ». Для проверки наличия услуги на вашем номере воспользуйтесь Интернет-Помощником или позвоните 
#в Контактный центр по телефону 0890.
#На тарифном плане «Гостевой 08», «Гостевой+», «Гостевой‘», «Твоя страна» (все модификации) невозможно подключение в качестве любимой страны всех стран СНГ, Абхазии, Грузии, Южной Осетии. Подключение опции «Любимая страна. Весь Мир» доступно.
#Если на вашем тарифном плане была подключена услуга «Родные страны», то при подключении опции «Любимая страна» действие услуги «Родные страны» прекращается.
#При выборе России в качестве любимой страны абонент получает специальную тарификацию звонков абонентам всех операторов фиксированной и подвижной связи России 
#за исключением абонентов операторов связи г. Москва и Московской области.

#Тарифы и география
#Тарифы на звонки в различные страны приведены в прайс-листе.
#Тарификация звонков при подключении тарифной опции «Любимая страна. Весь Мир» также осуществляется по указанным тарифам.
