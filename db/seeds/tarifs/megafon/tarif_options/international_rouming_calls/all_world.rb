@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_all_world, :name => 'Весь мир', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/allworld.html',
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

scg_mgf_all_world = @tc.add_service_category_group(
  {:name => 'scg_mgf_all_world' }, 
  {:name => "price for scg_mgf_all_world"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 40.0, :price => 59.0}, :window_over => 'day' } } )

#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 0.0} } })  

#All world, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_world[:id])


@tc.add_tarif_class_categories

#–При нахождении в международном роуминге абоненты тарифных планов для физических лиц и корпоративных тарифных планов, в рамках опции «Весь Мир» могут принимать 30 бесплатных входящих минут в течение календарных суток независимо от использования: в рамках одного соединения или суммарно нескольких соединений. Начиная с 31 минуты, все входящие вызовы до конца суток будут тарифицироваться по роуминговым тарифам страны пребывания;
#–Под сутками подразумевается период с 00:00 до 23:59 по московскому времени;
#–Условия тарификации входящих вызовов по тарифной опции «Весь Мир» действуют только в международном роуминге;
#–Опцию могут подключить абоненты всех тарифных планов для физических лиц и корпоративных тарифных планов, за исключением ТП «Вокруг Света»;
#–Данная опция не работает совместно с другими опциями модифицирующими стоимость звонков в международном роуминге;
#–Стоимость услуг связи по тарифной опции не распространяется на вызовы, которые совершаются через сети спутниковой связи с помощью специального оборудования, а также на вызовы через сеть AT&T Mobility LLC (BMU01);
#–Срок действия Опций не ограничен. Опция действует до момента отключения услуги абонентом;
#–Включенные бесплатные минуты предоставляются только 1 раз в сутки. При исчерпании минут в течение суток, а также при повторном подключении опции новые минуты будут предоставлены с начала новых суток.
