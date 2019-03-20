@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_24_pro, :name => 'Интернет 24 PRO', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/internet_24_pro.html',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :mgf_internet_24 => [_mgf_internet_24, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl, 
      _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500],
#      :add_speed_mgf_internet_24 => [_mgf_internet_24, _mgf_add_speed_1gb, _mgf_add_speed_5gb,
#        _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500],
      }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_internet_24_pro = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_24_pro' }, 
    {:name => "price for scg_mgf_internet_24_pro"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 1500.0, :price => 150.0}, :window_over => 'day' } } )
 
  #internet for add_speed_1gb option
  scg_mgf_add_speed_1gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_1gb_mgf_internet_24_pro' }, 
    {:name => "price for scg_mgf_add_speed_1gb_mgf_internet_24_pro"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 150.0} } }
    )

  #internet for add_speed_4gb option
  scg_mgf_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_5gb_mgf_internet_24_pro' }, 
    {:name => "price for scg_mgf_add_speed_5gb_mgf_internet_24_pro"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 5000.0, :price => 40.0} } }
    )

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_24_pro[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb] )

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_24_pro[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb] )


@tc.add_tarif_class_categories

#-При въезде в регионы, где технически доступна сеть 4G+, услуги по передаче данных будут предоставляться автоматически в сетях 4G+ при наличии у абонента мобильного устройства, поддерживающего технологию LTE (4G+), и USIM-карты.
#-Максимально достижимая скорость в каждом конкретном случае зависит от технических возможностей сети и оборудования, с помощью которого вы осуществляете доступ в Интернет. 
#-Опция доступна для подключения на всех тарифах, кроме тарифов серии «МегаФон — Все включено», «Видеоконтроль», «Детский Интернет», «МегаФон-Логин Оптимальный», «ММС-Камера».
#-Сверх 200 МБ в сутки далее до начала новых суток действует тариф 0,5 ₽ за 1 МБ (с почасовым округлением до 1 КБ).
#-Плата за пользование опцией «Интернет 24» не списывается, если в течение суток вы не пользовались мобильным интернетом. Сутки считаются с 00:00 до 24:00.
#-Опция не подключается совместно с другими опциями и пакетами мобильного интернета с включенным объемом интернет-трафика на максимальной скорости. 
#-Для подключения новой опции необходимо отключить имеющуюся опцию/пакет.
#-При отказе от опций отключение происходит с текущего момента. 
#-При достижении включенного объема трафика доступ в Интернет приостанавливается и автоматически возобновляется при подключении опций линейки «Продли скорость».
