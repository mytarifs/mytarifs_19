@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_minute_packs_50_world, :name => 'Пакеты минут 50 Мир', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/minute_packs.html',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :international_calls_options => [
        _mgf_all_world, _mgf_minute_packs_25_europe, _mgf_minute_packs_50_europe, _mgf_minute_packs_25_world, _mgf_minute_packs_50_world, 
        _mgf_30_minutes_all_world, _mgf_far_countries, _mgf_option_around_world, _mgf_100_minutes_europe]
        }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
#    :is_archived => true,
    :multiple_use => false
  } } )


scg_minute_packs_50_world = @tc.add_service_category_group(
  {:name => 'scg_minute_packs_50_world' }, 
  {:name => "price for scg_minute_packs_50_world"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 50.0, :price => 1429.0}, :window_over => 'month' } } )

#Europe, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#Europe, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#Europe, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#Europe, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  


#sic, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#sic, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#sic, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#sic, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  


#Extended countries, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#Extended countries, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#Extended countries, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

#Extended countries, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_50_world[:id])  

@tc.add_tarif_class_categories

#–Пакеты доступны на всех тарифных планах, за исключением отдельных корпоративных. Срок действия каждого пакета ― 30 дней с момента заказа. Неиспользованные минуты по истечении 30 дней аннулируются. Возврат денег за неистраченные минуты не производится.
#Чтобы узнать число оставшихся предоплаченных минут, наберите кодовую команду *105*10#.
#–Пакет «30 минут Весь мир» действует во всех странах, где есть международный роуминг «МегаФон».
#–Минуты из оплаченного пакета расходуются на любые входящие вызовы с российских номеров (номеров страны пребывания), а также исходящие вызовы на российский номер (номер страны пребывания). Звонки в другие страны и остальные услуги связи оплачиваются по роуминговому тарифу страны пребывания.
#–Допускается одновременно подключить несколько пакетов.
