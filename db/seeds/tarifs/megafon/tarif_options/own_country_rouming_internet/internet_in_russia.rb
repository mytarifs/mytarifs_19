@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_in_russia, :name => 'Интернет по России', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/inet.html',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:mgf_internet_in_russia_1 => [_mgf_internet_in_russia, _mgf_internet_xl],
      :mgf_internet_in_russia => [_mgf_be_as_home, _mgf_internet_in_russia_for_specific_options, _mgf_internet_in_russia, _mgf_gigabite_to_road],
      }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Параметры опции задаются в описании самого тарифа

#Подключение услуги
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  
#  @tc.add_only_service_category_tarif_class(_sctcg_one_time_tarif_switch_on)  

#Ежедневная плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, :formula => {:params => {:price => 10.0} } })
#  @tc.add_only_service_category_tarif_class(_sctcg_periodic_day_fee)  

#Own country, Internet
category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_only_service_category_tarif_class(category)  



@tc.add_tarif_class_categories

#Опция начинает действовать через 10–15 минут после подключения.
#Опция доступна для абонентов, использующих тарифные планы «МегаФон-Логин Оптимальный», «МегаФон-Онлайн с модемом 4G+» и пакеты безлимитного интернета от «МегаФон».
#Чтобы уточнить возможность подключения опции, зайдите в Личный кабинет (Сервис-Гид) и откройте меню «Услуги и тариф», либо позвоните в Контактный центр по номеру 0500.
#Опция действует в сетях 4G+/3G/2G по всей России, кроме Дальневосточного филиала ОАО «МегаФон», Таймырского муниципального района и г. Норильск, где тариф за 1 Мб составляет 9,9 руб., и Республики Крым и г. Севастополь, где тариф за 100 КБ составляет 19 руб.
#Отключение опции: *105*0042*0#.
