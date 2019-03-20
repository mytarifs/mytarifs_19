#Везде как дома ULTRA
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_everywhere_as_home_Ultra, :name => 'Везде как дома ULTRA', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/calls_across_russia/discounts/vkd_ulrta/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {:everywhere_as_home => [_mts_everywhere_as_home, _mts_everywhere_as_home_Ultra, _mts_everywhere_as_home_smart]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [_mts_everywhere_as_home], :higher => []},
    :prerequisites => [_mts_ultra],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )
#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_everywhere_as_home_Ultra_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_everywhere_as_home_Ultra_calls' }, 
    {:name => "price for scg_mts_everywhere_as_home_Ultra_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 5000.0, :price => 0.0}, :window_over => 'month' } }
    )

 
#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 400.0} } })
 
#Own country, Calls, incoming
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own country, Calls, Outcoming, to_own_home_regions, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_everywhere_as_home_Ultra_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own country, Calls, Outcoming, to_own_home_regions, to_other_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_everywhere_as_home_Ultra_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } })

#Own country, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_everywhere_as_home_Ultra_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

@tc.add_tarif_class_categories

#Особые условия тарификации при звонках на междугородные номера и звонках в поездках по России для абонентов тарифного плана «ULTRA»
#На тарифном плане «ULTRA» в первоначальный и обязательный пакеты услуг включена опция «Везде как дома ULTRA».

#При подключении опции при нахождении на территории всей России в сети МТС:
#при звонках на все номера России расходуется включенный в тариф пакет 5000 минут;
#сверх пакета минут исходящие вызовы на мобильные МТС любых регионов России бесплатны;
#все входящие вызовы бесплатны.

#Ежемесячная плата за опцию «Везде как дома ULTRA» - 400 руб.
#Взимается один раз в месяц в полном объеме: первый раз - в момент добавления опции, в последующие периоды - каждый месяц, начиная со второго, в день соответствующий дате подключения опции.

#Подключить / отключить опцию можно, набрав на своем телефоне команду *111*7771#вызов.

#В случае отключения опции:
#- при нахождении в домашнем регионе:
#    - включенный в тариф пакет 5000 минут действует только при звонках на мобильные телефоны МТС всей России, а также на мобильные и городские телефоны г. Москвы и Московской области
#    - исходящие вызовы на междугородные номера других операторов связи России оплачиваются по базовому тарифу на междугородные вызовы; включенный в тариф пакет 5000 минут на данное направление не действует;
#- при нахождении в поездках по России в сети МТС:
#    - все входящие и исходящие вызовы оплачиваются по базовым тарифам внутрисетевого роуминга, включенный в тариф пакет 5000 минут не действует.