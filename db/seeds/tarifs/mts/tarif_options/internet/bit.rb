#БИТ
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_bit, :name => 'БИТ', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/tarifu/unlim_options/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
      :internet_comp => [_mts_mini_bit, _mts_bit, _mts_super_bit, _mts_additional_internet_500_mb, _mts_additional_internet_1_gb, 
        _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_mts_mini_bit], :higher => [_mts_unlimited_internet_on_day, _mts_turbo_button_100_mb, _mts_turbo_button_500_mb, _mts_turbo_button_1_gb, _mts_turbo_button_2_gb, _mts_turbo_button_5_gb]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart, _mts_smart_mini, _mts_smart_bezlimitishe, _mts_smart_plus, _mts_smart_top, _mts_smart_nonstop, _mts_ultra, _mts_mts_connect_4], :to_serve => []},
    :multiple_use => false
  } } )

  #internet for add_speed_100mb option
  scg_mts_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_100mb_mts_bit' }, 
    {:name => "price for scg_mts_add_speed_100mb_mts_bit"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay, 
      :formula => {:params => {:max_sum_volume => 100.0, :price => 30.0} } }
    )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 200.0} } })

#Own and home regions rouming, internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice,  
      :formula => {:params => {:max_sum_volume => 75.0, :price => 0.0}, :window_over => 'day' } } )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_100_mb] )
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice,  
      :formula => {:params => {:max_sum_volume => 50.0, :price => 8.0}, :window_over => 'day' } } )
    
@tc.add_tarif_class_categories

#Как подключить/отключить
#Есть три способа подключить опцию «БИТ»:
#наберите на своем мобильном телефоне *252#звонок или *111*252*1#звонок  
#отправьте SMS с текстом 252  на номер 111;
#воспользуйтесь «Интернет-Помощником»

#Есть три способа отключить опцию «БИТ»:
#наберите на своем мобильном телефоне *252*0#звонок или *111*252*2#звонок  
#отправьте SMS с текстом 2520  на номер 111;
#воспользуйтесь «Интернет-Помощником»

#Кто может подключить
#Опцию «БИТ» и «СуперБИТ» могут подключить абоненты всех тарифных планов за исключением тарифных планов фиксированной связи, 
#а также линеек тарифных планов «МТС Коннект», «Ultra», "VIP", "MAXI", "MAXI Smart","Классный", «Заботливый», «Онлайнер», 
#«Супер-Онлайнер», SIM, «i-Онлайнер», «МТС iPad», «1-2-3», «Персонал Х5», «400 за 600», "1000 за 1300", "Smart mini", "Smart", "Smart +", "Smart + на год" и всех модификаций

#Условия предоставления
#Опции «БИТ», «СуперБИТ» действительны для абонентов г. Москвы и Московской области
#При превышении суточной квоты трафика 75 Мб для опции «БИТ» скорость доступа в Интернет снижается до 64 Кбит/сек до конца текущих суток (сутки рассчитываются от 03:00 до 03:00 следующих суток).
#При превышении месячной квоты трафика 3 Гб для опции «СуперБИТ» скорость доступа в Интернет снижается до 64 Кбит/сек до конца текущего месяца (месяц рассчитывается от 03:00 до 03:00 текущей даты следующего месяца).
#Фактическая скорость может отличаться от заявленной и зависит от технических параметров сети мобильной связи МТС и от других обстоятельств, влияющих на качество связи.
#При одновременном использовании опций «БИТ» или «СуперБИТ» и «Безлимитный Интернет на сутки» ограничение по скорости вступает в силу после превышения суточной квоты трафика 1024 Мб. При сохранении ограничений по скорости в случае отключения услуги необходимо разорвать GPRS-соединение и установить его заново.
#Точка доступа (APN): internet.mts.ru, wap.mts.ru.
#Интернет-опции не действуют при выходе на сайты с премиальной тарификацией
#В рамках тарифных опций «БИТ» и «СуперБИТ» ограничено предоставление услуг файлообменных сетей.

#Одновременное подключение опций
#Тарифные опции «БИТ» и «СуперБИТ» являются взаимоисключающими между собой и всеми модификациями опций «БИТ 2012», «СуперБИТ 2012», «БИТ 2013», «СуперБИТ 2013», 
#«БИТ (042014)», «СуперБИТ (042014)»,«СуперБИТ_free», «БИТ 2011», «Интернет+», «Интернет-оптимизация», «Безлимитный ночной Интернет», «Безлимитный Интернет», 
#«Интернет за копейки», «Безлимитный Интернет RED Energy», «Интернет-пакет 200 Мб», «Интернет- пакет 300 Мб», «Интернет-пакет 450 Мб», «Интернет-пакет 900 Мб», 
#Real IP, «Интернет-Mini/Maxi/Super/VIP», «МТС Планшет», «БИТ+Мобильное ТВ» и всеми их модификациями.
#При одновременном подключении опций «СуперБИТ» и «БИТ_Ultra» или «Все, что нужно» действуют условия опции «СуперБИТ».
#При одновременном подключении опции «БИТ» и «Все, что нужно» действуют условия опции «Все, что нужно».
#При одновременном подключении опций «СуперБИТ» и «Безлимитный Интернет на сутки» действуют условия опции «Безлимитный Интернет на сутки». 
#При одновременном подключении опций «БИТ» и «Безлимитный Интернет на сутки» действуют условия опции «Безлимитный Интернет на сутки». 
#По истечении срока действия опции «Безлимитный Интернет на сутки» вступают в силу условия опции «СуперБИТ» / «БИТ».
#При наличии опций «БИТ» и «СуперБИТ» опции «БИТ Smart» и «СуперБИТ Smart» недоступны для подключения.

#Автоматическое информирование о достижении лимитов
#Все клиенты МТС, у которых подключены тарифные опции БИТ или СуперБИТ, при достижении часовых и суточных квот трафика получают информирующие SMS с информацией о подключенной опции, действующей квоте и времени, оставшемся до восстановления скорости.
#Операция                         МТС Сервис *111#  SMS на короткий номер 5340
#Подключение SMS-уведомления    *111*218#вызов        info 
#Проверка текущего статуса      *111*217#вызов          ? 
#Отключение SMS-уведомления     *111*219#вызов        stop 
#SMS на номер 5340 бесплатны при нахождении абонента в регионе регистрации номера.

#Сколько стоит
#В момент подключения тарифной опции списывается плата за подключение, равная размеру ежемесячной платы (ежемесячная плата за первый месяц не списывается), 
#далее каждый месяц в день, соответствующий дате подключения опции, независимо от количества средств на счете списывается ежемесячная плата. 
#Если номер заблокирован, плата взимается сразу после выхода из блокировки.
#Отключение опций – бесплатно.
