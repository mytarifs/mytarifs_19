#Родные города
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_rodnye_goroda, :name => 'Родные города', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/calls_across_russia/discounts/r_goroda/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => [_mts_love_country_all_world]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart_bezlimitishe], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )


#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 34.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 3.5} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

@tc.add_tarif_class_categories

#наберите на своем телефоне команду *111*2132#вызов
#отправьте SMS на номер 111 с текстом 2132 для подключения / с текстом 21320 для отключения опции

#Акция «Родные города» - это возможность совершать междугородные  звонки абонентам МТС других регионов России по привлекательно низкой цене. 
#Для участия в акции подключите услугу «Родные города» и Ваши исходящие звонки абонентам МТС в другие города России будут стоить 2,5 руб. за минуту!

#Стоимость
#ежедневная плата за услугу 3,5 руб.;
#стоимость подключения услуги 34 руб.;
#отключение – 0 руб.
 
#Подробнее о подключении
#Услуга «Родные города» доступна для подключения абонентам всех некорпоративных тарифных планов 
#за исключением тарифных планов «Европейский», «Единственный», «Бизнес без границ», линейки тарифов «Экслюзив», «Гостевой», «Твоя страна», ULTRA.»

#Подключение/отключение Услуги «Родные города» производится по инициативе абонента.
#При одновременном участии в акции «Родные города» и в кампании «Прогрессивный годовой контракт», скидка на исходящие вызовы абонентам МТС России предоставляется 
#в рамках акции «Родные города».

#Предложение действительно для абонентов МТС г. Москвы и Московской области на территории г. Москвы и Московской области. Все цены указаны в рублях с учетом налогов
