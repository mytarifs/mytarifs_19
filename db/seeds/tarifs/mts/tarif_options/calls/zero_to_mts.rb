#Ноль на МТС
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_zero_to_mts, :name => 'Ноль на МТС', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/discounts/discounts_in_region/calls_on_number_mts/zero_mts/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {:zero_to_mts => [_mts_call_free_to_mts_russia_100, _mts_zero_to_mts]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mts_super_mts],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } ) 
 
#calls included in tarif
scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls = @tc.add_service_category_group(
  {:name => 'scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls' }, 
  {:name => "price for scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'day' } }
    )
  
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 3.5} } })  

#Плата за использование
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 105.0} } })

#own region rouming    

#Own and home regions, calls, outcoming, to_own_and_home_region, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls[:id])

#Own and home regions, calls, outcoming, to_own_and_home_region, to_fixed_line
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::FixedlineOperator] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls[:id])

#Own region, calls, outcoming, to own country, to own operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'day' } } )

@tc.add_tarif_class_categories

#С 9 июня 2014 года подключайте на архивных тарифных планах линейки «Супер Ноль» и линейки «Супер МТС» опцию «Ноль на МТС» и общайтесь со своими родными и близкими бесплатно!
#При подключении опции «Ноль на МТС» абоненту ежесуточно предоставляется 100 бесплатных минут в сутки на звонки абонентам МТС Москвы и Московской области и 
#городские телефоны г. Москва, а также 100 бесплатных минут в сутки на звонки на номера МТС России.

#Стоимость подключения — 3,50 руб.
#Ежесуточная плата — 3,50 руб.

#Как подключить / отключить
#Есть три способа подключить / отключить опцию «Ноль на МТС»:
#наберите на своем мобильном телефоне: *899# – для подключения;
#*111*899# – для подключения или отключения и выберите соответствующий пункт меню;
#отправьте SMS на номер 111 с текстом: 899 – для подключения;
#8990 – для отключения;
#воспользуйтесь Личным кабинетом.

#Сколько стоит
#Стоимость подключения — 3,50 руб
#Ежесуточная плата — 3,50 руб.
#Стоимость подключения входит в стоимость первого дня использования опции. Плата за опцию списывается (в полном объеме) в ночь за следующие сутки.
#Чтобы узнать о количестве оставшихся бесплатных минут (в сутки), воспользуйтесь Интернет-Помощником или наберите на своем мобильном телефоне *100*1#.

#Опция «Ноль на МТС» предоставляет скидку 100% на исходящие вызовы по направлению МТС Москвы и Московской области и городские номера Москвы, 
#совершенные в Москве и Московской области, в размере 100 минут в сутки и скидку 100% на исходящие вызовы на МТС России, 
#совершенные в Москве и Московской области, в размере 100 минут в сутки.
#При подключении опции «Ноль на МТС» бесплатные минуты, предоставляемые за пополнение счета, не действуют. 
#Бесплатные минуты, предоставляемые на вызовы на номера МТС Москвы и Московской области в рамках базовых условий тарифа, 
#не суммируются с минутами на номера МТС Москвы и Московской области, предоставляемых по опции «Ноль на МТС».
#Все цены указаны с учетом НДС.
