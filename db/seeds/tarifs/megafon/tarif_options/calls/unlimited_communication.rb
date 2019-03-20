@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_unlimited_communication, :name => 'Безлимитное общение', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {
    :http => 'http://moscow.megafon.ru/tariffs/options/megafon_calls/bezlimitnoe_obschenie.html',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },  
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => [_mgf_be_as_home]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_xl, _mgf_all_included_vip,], :to_serve => []},
#    :is_archived => true,
    :multiple_use => false
  } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 30.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 10.0} } })
  
#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'day' } }
    )

#Tarif option 'Будь как дома'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 15.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Megafon] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'month' } },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  


@tc.add_tarif_class_categories

#Опция «Безлимитное общение» недоступна на тарифных планах: «МегаФон — Все включено S», «МегаФон — Все включено М», «МегаФон — Все включено L», «МегаФон — Все включено VIP».
#Внимание: «Безлимитное общение» невозможно подключить, если абонент пользуется опцией: «Беззаботные выходные», «Безлимитные выходные», «Белые ночи», «МегаЗвонки», «МегаЗвонки +», «МегаРоссия», «МегаРоссия +», «Своя сеть», «Своя сеть’» или «Час на МегаФон».
#При осуществлении абонентом нескольких исходящих вызовов одновременно (конференц-связь) пакет расходуется на каждое соединение.
#Возможность заказа тарифной опции будущей датой не предоставляется.
#Действие тарифной опции прекращается в момент ее отключения.
#После исчерпания суточного объема минут до начала новых суток действуют тарифы согласно тарифному плану абонента.
#При отключении опции неиспользованный объем минут не сохраняется и не компенсируется.

#Сутки считаются с 00:00:00 до 23:59:59.
#Чтобы начал действовать пакет нетарифицируемых минут нового дня, необходимо прерывание вызова в 23:59:59.
#Опция «Безлимитное общение» действует на территории Домашнего региона.
#Подключение ТО происходит только при наличии необходимой суммы на счете абонента. Если необходимая сумма (размер платы за подключение ТО и абонентской платы за ТО) отсутствует — то подключение не происходит. Плата за подключение и абонентская плата начисляются в момент подключения тарифной опции. 
#В рамках тарифной опции указана стоимость всех платных вызовов по направлениям, указанным выше, кроме платных переадресованных вызовов (а также переадресации на голосовую почту) и платных вызовов по приему и передаче факсов и данных.
