#Входящие в поездках по России
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_incoming_travelling_in_russia, :name => 'Входящие в поездках по России', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/n_roaming/discounts/incoming_calls/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение опции
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })

#Own country, calls, from rouming region, from own_operator
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}} # temporary :service_category_geo_id => _service_to_rouming_region,
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

@tc.add_tarif_class_categories

#Как подключить/отключить опцию
#Есть три способа подключения/отключения опции:
#наберите на своем мобильном телефоне *111*473#вызов ;
#воспользуйтесь Интернет-Помощником;
#отправьте SMS на номер 111: с текстом 473 – для подключения;
#с текстом 4730 –для отключения

#Опция «Входящие в поездках по России» доступна для подключения на всех тарифных планах МТС.

#Сколько стоит - Подключение и использование опции – 0 рублей. 

#Условия предоставления
#Опция действует при нахождении за пределами домашнего региона, на всей территории Российской Федерации при регистрации в сети МТС.

#Стоимость остальных входящих и всех исходящих вызовов при подключении опции оплачивается согласно базовым тарифам внутрисетевого роуминга

