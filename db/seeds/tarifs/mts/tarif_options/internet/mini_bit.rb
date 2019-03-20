#МиниБИТ
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_mini_bit, :name => 'МиниБИТ', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/internet_phone/additionally_services/minibit/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
      :internet_comp => [_mts_mini_bit, _mts_bit, _mts_super_bit, _mts_additional_internet_500_mb, _mts_additional_internet_1_gb, _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip], 
    }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_mts_bit, _mts_internet_super, _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, 
      _mts_internet_vip, _mts_unlimited_internet_on_day, 
      _mts_turbo_button_100_mb, _mts_turbo_button_500_mb, _mts_turbo_button_1_gb, _mts_turbo_button_2_gb, _mts_turbo_button_5_gb]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart, _mts_smart_mini, _mts_smart_bezlimitishe, _mts_smart_plus, _mts_smart_top, _mts_ultra, _mts_mts_connect_4], :to_serve => []},
    :multiple_use => true
  } } )

  #internet for add_speed_100mb option
  scg_mts_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_100mb_mts_mini_bit' }, 
    {:name => "price for scg_mts_add_speed_100mb_mts_mini_bit"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay, 
      :formula => {:params => {:max_sum_volume => 100.0, :price => 30.0} } }
    )
 
#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })

#Own and Home regions rouming, internet
category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 10.0, :price => 20.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 10.0, :price => 10.0}, :window_over => 'day' } } )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_100_mb] )

#Own country, internet
category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 10.0, :price => 40.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 10.0, :price => 20.0}, :window_over => 'day' } } )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_100_mb] )

@tc.add_tarif_class_categories

#Как подключить/отключить
#Есть три способа подключить опцию «БИТ»:
#наберите на своем мобильном телефоне *62#звонок или *111*62*1#звонок  
#отправьте SMS с текстом 62  на номер 111;
#воспользуйтесь «Интернет-Помощником»

#Есть три способа отключить опцию «БИТ»:
#наберите на своем мобильном телефоне *62*0#звонок или *111*62*2#звонок  
#отправьте SMS с текстом 620  на номер 111;
#воспользуйтесь «Интернет-Помощником»

#Стоимость исходящего SMS на номера 111 - 0 руб. при нахождении на территории Российской Федерации в сети МТС и в международном роуминге.


#Кто может подключить 
#Подключение/отключение «МиниБИТ» доступно на всех тарифных планах, за исключением:
#всех тарифных планов линейки «МТС-Коннект»;
#тарифных планов «SiM», «i-Онлайнер», «Онлайнер», «Супер Онлайнер», «МТС iPad» и их модификаций;
#тарифных планов «MAXI», «Ultra», «Smart», «Smart+», «Классный», «Заботливый» и всех их модификаций;
#При подключении, либо переходе на тарифные планы «Супер МТС», «Red Energy», «Твоя страна» опция «МиниБИТ» будет подключена по умолчанию, 
#при этом опция доступна для отключения.

#Где действует опция
#Опция «МиниБИТ» действует для абонентов сети мобильной связи МТС г. Москвы и Московской области при нахождении на территории России.
#Действие и параметры опции «МиниБИТ» распространяются на трафик через точку доступа (АPN) internet.mts.ru, wap.mts.ru (трафик через АPN internet.mts.ru тарифицируется по стоимости 0 руб.) и не распространяется на трафик через остальные АPN (realip.msk, корпоративные АPN и пр.).

#Учет интернет-трафика в суточной квоте трафика – покилобайтный.

#Одновременное подключение опций
#Тарифная опция «МиниБИТ» является взаимоисключающей со всеми модификациями Интернет-пакетов и со всеми модификациями архивных опций: 
#«Интернет+», «Интернет-оптимизация», «Безлимитный ночной Интернет», «Интернет за копейки», «Бюджетный безлимит», «Безлимит для Яндекс.Карты».
#При одновременном подключении опций «МиниБИТ» и «БИТ» в домашнем регионе действуют условия опции «БИТ», 
#а во внутрисетевом роуминге - условия опции «МиниБИТ».
#При одновременном подключении опций «МиниБИТ» и «Безлимит на день по России» в домашнем регионе и во внутрисетевом роуминге 
#действуют условия опции «МиниБИТ».
#При одновременном подключении опции «МиниБИТ 2013» и «Безлимит на день по России» действуют условия опции «Безлимит на день по России» , 
#т. е. ограничение скорости в этом случае наступит при превышении суммарного объема 2048 Мбайт трафика в период действия услуги.
#При одновременном подключении опций «МиниБИТ» и «СуперБИТ» действуют условия опции «СуперБИТ».
#При одновременном подключении опций «МиниБИТ» и «Безлимит-Mini/Maxi/Super/VIP», «Интернет-Mini/Maxi/Super/VIP» и всех их модификаций 
#действуют условия опций «Безлимит-Mini/Maxi/Super/VIP», «Интернет-Mini/Maxi/Super/VIP» и всех их модификаций.
#При одновременном подключении опций «МиниБИТ» и «Все, что нужно» действуют условия опции «Все, что нужно».
#При одновременном подключении опций «МиниБИТ» и «Безлимитный Интернет на сутки» действуют условия опции «Безлимитный Интернет на сутки». По истечении срока действия опции «Безлимитный Интернет на сутки» вступают в силу условия опции «МиниБИТ».

#Условия предоставления
#При превышении суточной квоты трафика 10 Мб для опции «МиниБИТ» скорость доступа в Интернет ограничивается до 32 Кбит/с до конца текущих суток (сутки рассчитываются от 03:00 до 03:00 следующих суток). Фактическая скорость может отличаться от заявленной и зависит от технических параметров сети мобильной связи МТС и от других обстоятельств, влияющих на качество связи.
#Если абонент в течение дня будет находиться в домашнем регионе и во внутрисетевом роуминге, то ежесуточная плата спишется 
#и по тарифу для домашнего региона и по тарифу для внутрисетевого роуминга. 
#Абоненту будет предоставлено две квоты: 10 Мб для домашнего региона и 10 Мб для ВСР.
#Например:
#У абонента подключена опция «МиниБИТ».
#Размер суточной квоты составляет 10 Мб.
#Абонент вышел в Интернет в Москве и Московской обл., и скачал 9 Мб.,с лицевого счета списано 20 руб. 
#В этот же день абонент выехал за пределы Москвы и Московской обл. и тоже вышел в Интернет и скачал еще 9 Мб., 
#с лицевого счета будет списана плата 40 руб.

#В период и в зоне действия опции стоимость Интернет-трафика - 0 руб./Мб.
#Скорость доступа в пределах суточной квоты 10Мб в домашнем регионе и 10Мб во внутрисетевом роуминге не ограничена, далее скорость ограничивается 32Кбит/с.
#Действие опции распространяется на точку доступа (APN) internet.mts.ru, wap.mts.ru.

#Все цены указаны с учетом НДС.
#Тарификация за доступ в Интернет происходит в момент первого выхода в Интернет. В период и в зоне действия опции стоимость Интернет-трафика - 0 руб./Мб.
#Автоматическое информирование о достижении квот трафика
#Все абоненты сети мобильной связи МТС, у которых подключена тарифная опция «МиниБИТ», при достижении суточной квоты трафика получают SMS-уведомление о подключенной опции, действующей квоте и времени, оставшемся до восстановления скорости.
 

#Операция                       МТС Сервис *111#  SMS на короткий номер 5340
#Подключение SMS-уведомления    *111*218#вызов      info 
#Проверка текущего статуса      *111*217# вызов     ? 
#Отключение SMS-уведомления     *111*219# вызов     stop 

#SMS на номер 5340 бесплатны при нахождении абонента в регионе регистрации номера. Во внутрисетевом, национальном и международном роуминге тарификация осуществляется согласно роуминговым тарифам на исходящие SMS.
