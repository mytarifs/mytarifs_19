#Безлимитные звонки
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_unlimited_calls, :name => 'Безлимитные звонки', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/discounts/discounts_in_region/calls_on_number_mts/unlim_call/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_red_energy, _mts_a_mobile, _mts_smart, _mts_smart_mini, _mts_smart_bezlimitishe, _mts_smart_plus, _mts_ultra, _mts_super_mts, _mts_smart_top], 
      :to_serve => [_mts_a_mobile]}, 
    :is_archived => true,
    :multiple_use => false
  } } )

#TODO добавить разную тарификацию для разных регионов. В Московской области - 1 руб, а в Ленинградской - 47 коп.
  
#Плата за использование
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 10.0} } })

#Own region, Calls, outcoming, to own and home regions, to own operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

@tc.add_tarif_class_categories

#Опция «Безлимитные звонки» — это неограниченное общение с абонентами сети мобильной связи МТС г. Москвы и Московской области всего за 10 рублей в сутки!
#TODO#@Опция не предоставляется на тарифе «Супер Ноль», «А-Мобайл», Maxi One, корпоративных тарифах и тарифах, где безлимитные звонки на МТС уже включены в условия тарифного плана. 
#На тарифах линейки  «Супер МТС» опция доступна для обслуживания, но не доступна для подключения.

#Опция действует при нахождении абонента в г. Москве и Московской области.
#Подробности
#Вызовы абонентам сети мобильной связи МТС г. Москвы и Московской области тарифицируются по стоимости 0 руб. при нахождении в г. Москве и Московской области. 
#Действие опции не распространяется на направление «Прослушивание Голосовой/факсимильной почты» (вызов на 0860).

#Если у абонента подключены опции «Номера МТС», «Свободное время», «Безлимитные звонки’», то при подключении опции «Безлимитные звонки», действующие опции отключатся.
#Если опция «Безлимитные звонки» действует одновременно с другими опциями, предоставляющими скидку на вызовы абонентам сети мобильной связи МТС г. Москвы и Московской области, 
#то абоненту будет предоставлена 100% скидка на вызовы абонентам сети мобильной связи МТС г. Москвы и Московской области.
#При наличии на тарифном плане абонента пакетов минут, вызовы по опции «Безлимитные звонки» не расходуют минуты из данных пакетов.

#Вызовы по опции «Безлимитные звонки» не учитываются в накоплении местных минут на тарифных планах «Много звонков», «Много звонков+», «Много звонков на все сети», «Свободный».
#До 1 июля 2011 г. опция называлась «Безлимит на МТС».

#Как подключить
#Есть три способа подключения:
#наберите на своем мобильном телефоне *111*2120# вызов ;
#отправьте SMS с текстом 2120 на номер 111;
#воспользуйтесь Интернет-Помощником.

#Как отключить
#Есть три способа отключения:
#наберите на своем мобильном телефоне *111*2120# вызов ;
#отправьте SMS с текстом 21200 на номер 111 (для абонентов, подключивших опцию до 30.06.2011 г.) или с текстом 212000 на номер 111 (для абонентов, подключивших опцию с 01.07.2011 г.);
#воспользуйтесь Интернет-Помощником.

#Сколько стоит
#Ежедневная плата — 10 руб.
