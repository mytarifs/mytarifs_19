@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_everywhere_moscow_in_central_region, :name => 'Везде Москва — в Центральном регионе', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/mskcenter.html',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :mms_options => [_mgf_mms_24, _mgf_paket_mms_10, _mgf_paket_mms_50, _mgf_everywhere_moscow_in_central_region],
      :sms_options => [_mgf_option_for_sms_s, _mgf_option_for_sms_l, _mgf_option_for_sms_m, _mgf_option_for_sms_xl, _mgf_sms_stihia, _mgf_paket_sms_100,
        _mgf_paket_sms_150, _mgf_paket_sms_200, _mgf_paket_sms_350, _mgf_paket_sms_500, _mgf_paket_sms_1000, _mgf_100_sms, _mgf_everywhere_moscow_in_central_region],
      :calls_options => [_mgf_unlimited_communication, _mgf_call_to_russia, _mgf_call_to_all_country, _mgf_option_city_connection, _mgf_everywhere_moscow_in_central_region],
      :intra_country_rouming => [_mgf_be_as_home, _mgf_all_russia, _mgf_travel_without_worry, _mgf_everywhere_moscow_in_central_region],
     }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Параметры опции задаются в описании самого тарифа

#Подключение услуги
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } })  
#  @tc.add_only_service_category_tarif_class(_sctcg_one_time_tarif_switch_on)  

#Ежедневная плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 5.0} } })
#  @tc.add_only_service_category_tarif_class(_sctcg_periodic_day_fee)  

#Central regions RF except for Own and home regions, Calls
category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_only_service_category_tarif_class(category)  

#Central regions RF except for Own and home regions, sms
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_and_home_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_only_service_category_tarif_class(category)  
category = {:uniq_service_category => 'own_country_regions/sms_out/to_own_country_regions', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_only_service_category_tarif_class(category)  
category = {:uniq_service_category => 'own_country_regions/sms_out/to_abroad', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_only_service_category_tarif_class(category)  

#Central regions RF except for Own and home regions, mms
category = {:uniq_service_category => 'own_country_regions/mms_in', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Mgf_central_region, :name => 'Мегафон, Центральный регион, кроме домашнего' }}}
  @tc.add_only_service_category_tarif_class(category)  



@tc.add_tarif_class_categories

#–Тарифная опция начинает действовать через 10–15 минут после подключения.
#–Опция действует в российской сети «МегаФон» за пределами Московской области в регионах, указанных выше.
#–При использовании тарифной опции «Везде Москва – в Центральном регионе» действуют только Интернет-опции (как дополнительно подключаемые, так и предоставляемые по условиям тарифного плана): опции с зоной действия «Вся Россия» действуют автоматически, а если подключена Интернет-опция с зоной действия «Московский регион», то для ее использования в других регионах страны необходимо дополнительно подключить опцию «Интернет по России».
#–Все остальные опции и услуги, а также льготные тарифы и скидки, меняющие цену услуг по тарифному плану (в том числе предоставляемые по условиям тарифного плана), не действуют.
#–Опция «Везде Москва ― В Центральном регионе» доступна для подключения абонентам большинства частных и корпоративных тарифных планов «МегаФон».
