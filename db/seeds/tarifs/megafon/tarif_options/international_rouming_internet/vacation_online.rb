@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_vacation_online, :name => 'Отпуск онлайн', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/online.html',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:internet_abroad_pakets => [_mgf_internet_abroad_10, _mgf_internet_abroad_30, _mgf_vacation_online]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 30.0} } })

#Specific countries, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Countries_vacation_online, :name => 'Страны Мегафона для опции Отпуск онлайн' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 19.0} } })  


@tc.add_tarif_class_categories

#–Тарифная опция действует в течение 30 дней с момента подключения.
#–Если абонент, подключивший опцию, находится в стране, где местное время отстает от московского, то скидка начнет действовать тогда, когда местное время совпадет со временем подключения опции по Москве.
#–Если абонент подключил «Запрет международного роуминга» или установил в опциях телефона запрет на передачу данных в роуминге, опция «Льготный роуминг» будет недоступна.
