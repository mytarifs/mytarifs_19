@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_my_sms, :name => 'Мои СМС', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moi-sms/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:sms_options => [_bln_sms_without_borders, _bln_my_sms, _bln_my_sms_post]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 25.0} } })  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 150.0} } })


#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 0.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.0} } })


@tc.add_tarif_class_categories


#Подключив опцию «Мои SMS», вы получаете возможность отправлять больше SMS  на любые местные номера по выгодной цене.
#Опция действует при нахождении абонента в домашней сети
#Опции «SMS мания», «SMS без границ», «SMS-пакеты», «Лёгкий смешанный пакет», «Средний смешанный пакет», «Тяжёлый смешанный пакет», «Полуночники», «SMS-движение», 
#«SMS скидка», «SMS свобода»:
#отключаются автоматически, если вы подключаете опцию «Мои SMS» по номеру 067471 или на сайте
#должны быть отключены заранее – до подключения опции «Мои SMS», если вы подключаете ее в Личном кабинете
#Если опция «Мои SMS» подключена вместе с другими пакетными SMS-опциями, местные SMS не суммируются. В этом случае вы можете отправить максимум 100 местных SMS в сутки по цене 0 рублей для тарифов предоплатной системы расчетов и 3000 местных SMS в месяц по цене 0 рублей для тарифов постоплатной системы расчетов. 
#Опция доступна всем абонентам предоплатной системы расчётов, на всех тарифных планах, за исключением тарифов «Go 2012», «Всe включено. Мир», «Всё включено L +», «Всё включено L 2013», «Всё включено L Люкс», «Все включено LTE», «Всё включено M 2013», «Всё включено XL», «Всё включено XXL +», «Все включено XXL 2011», «Всё включено XXL 2013», «Всё включено XXL Городской», «Всё включено XXL Люкс», «Всё включено Голд», «Всё включено.Максимум», «Всё за 600», «Всё за 1200», «Всё за 2700», «Доктрина 77», «Простая логика». 
#Опция доступна всем абонентам постоплатной системы расчётов, на всех тарифных планах, за исключением тарифов «Все включено XXL 2011», «Всё включено L 2013», «Всё включено XXL 2013», «Всё включено L *», «Всё включено XXL *», «Всё за 600», «Всё за 1450», «Всё включено XL», «Всё включено Максимум», «Всё за 1200», «Всё за 2700», «Всё за 2050», «Всё за 3550».  
