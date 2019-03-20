@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_xs, :name => 'Интернет XS', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/internet_xs.html',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:mgf_internet_24 => [_mgf_internet_24, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl, 
      _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_mgf_internet_in_russia_for_specific_options]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_xl, _mgf_all_included_vip], :to_serve => []},
    :multiple_use => false
  } } )

 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_internet_xs = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_xs' }, 
    {:name => "price for scg_mgf_internet_xs"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 70.0, :price => 0.0}, :window_over => 'day' } } )

 #internet for add_speed_70mb option
  scg_mgf_add_speed_70mb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_70mb_mgf_internet_xs' }, 
    {:name => "price for scg_mgf_add_speed_70mb_mgf_internet_xs"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 70.0, :price => 19.0} } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_xs[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_70mb[:id])

#Tarif option 'Интернет по России для определенных опций'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, :formula => {:params => {:price => 5.0} } },
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_xs[:id], :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_70mb[:id], :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )


@tc.add_tarif_class_categories

#-При въезде в регионы, где технически доступна сеть 4G+, услуги по передаче данных будут предоставляться автоматически в сетях 4G+ при наличии у абонента мобильного устройства, поддерживающего технологию LTE (4G+), и USIM-карты;
#-Максимально достижимая скорость в каждом конкретном случае зависит от технических возможностей сети и оборудования, с помощью которого Вы осуществляете доступ в Интернет;
#-Опция не подключается совместно с другими опциями и пакетами мобильного интернета с включенным объемом интернет-трафика на максимальной скорости;
#-Для подключения новой опции необходимо отключить имеющуюся опцию/пакет;
#-При отказе от опций отключение происходит с текущего момента;
#-При достижении включенного объема трафика доступ в Интернет приостанавливается и автоматически возобновляется с начала нового месяца, а также при подключении опций линейки «Продли скорость».
