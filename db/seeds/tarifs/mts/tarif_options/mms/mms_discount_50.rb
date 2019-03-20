#MMS+
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_mms_discount_50_percent, :name => 'MMS+', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/messaging/mms/discount2_mms/mms_plus/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_mms],
    :incompatibility => {:mms_packets => [_mts_mms_discount_50_percent, _mts_mms_packet_10, _mts_mms_packet_20, _mts_mms_packet_50]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

 
#Параметры опции задаются в описании самого тарифа
=begin
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 34.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 34.0} } })
=end

#Intranet rouming, mms, outcoming, to all own country regions, to own operator
  category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_only_service_category_tarif_class(category)  

  category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_only_service_category_tarif_class(category)  

  category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_only_service_category_tarif_class(category)  

  category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_only_service_category_tarif_class(category)  

@tc.add_tarif_class_categories
  

#TODO надо каким-то образом учитывать использование интернета при использовании ммс

#Получите скидку 50% от стоимости исходящих MMS, отправляемых абонентам сети МТС любого региона России, с услугой MMS+. 

#Стоимость подключения услуги «MMS+»: 34 руб.
#Стоимость отключения услуги «MMS+»: 0 руб.
#Плата за пользование услугой: 34 руб. в месяц
#Стоимость исходящего MMS без подключения «MMS+»: 6,50 руб.
#Стоимость исходящего MMS c подключением «MMS+»: 3,25 руб. (разная для разных тарифов)
  
#Для подключения наберите на телефоне компанду *111*10#.

#Как тарифицируется
#Стоимость подключения услуги списывается единовременно в момент ее подключения. Ежемесячная плата списывается до момента отключения услуги ежедневно, 
#равными частями пропорционально количеству дней в месяце.
#При нахождении абонента в домашней сети и во внутрисетевом роуминге МТС GPRS-трафик при передаче MMS не тарифицируется. 
#При нахождении абонента в национальном или международном роуминге GPRS-трафик при передаче MMS тарифицируется в полном объеме.

#Кто может подключить и где работает
#Предложение действительно для абонентов МТС г. Москвы и Московской области при нахождении в Москве, Московской области и во внутрисетевом роуминге МТС.

#Услуга доступна в роуминге при подключении GPRS-роуминга.
#Для пользования услугой «MMS+» необходимо наличие подключенной бесплатной услуги «GPRS» и соответствующих настроек телефонного аппарата. 
#Для автоматической настройки наберите бесплатный номер 0876 и сохраните полученные настройки.

#Как подключить/отключить
#Есть три способа подключения и отключения услуги: отправьте SMS для подключения - с текстом 2146 на номер 111;
#для отключения – с текстом 21460 на номер 111;

#подключите/отключите услугу в Интернет-Помощнике.
#через приложение «МТС Сервис»
