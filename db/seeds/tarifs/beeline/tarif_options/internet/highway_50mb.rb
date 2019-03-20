@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_highway_50mb, :name => 'Хайвей 50 Мб', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'https://moskva.beeline.ru/customers/products/mobile/services/details/highway-50mb/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:internet_options => [_bln_highway_1, _bln_highway_4, _bln_highway_8, _bln_highway_12, _bln_highway_20, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_bln_add_speed_1gb, _bln_add_speed_3gb, _bln_auto_add_speed]},
    :prerequisites => [], #[_bln_all_for_300, _bln_all_for_500, _bln_all_for_800, _bln_all_for_1200, _bln_all_for_1800, _bln_all_for_500_post, _bln_all_for_800_post, _bln_all_for_1200_post, _bln_all_for_1800_post, _bln_total_all_post],
    :forbidden_tarifs => { :to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Добавление новых service_category_group
#internet included in tarif
scg_bln_highway_50mb = @tc.add_service_category_group(
    {:name => 'scg_bln_highway_50mb' }, 
    {:name => "price for scg_bln_highway_50mb"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 50.0, :price => 30.0}, :window_over => 'month' } }
    )

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_50mb[:id])

#_sc_rouming_bln_cenral_regions_not_moscow_regions, Internet
  category = {:uniq_service_category => 'own_country_regions/internet', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Bln_cenral_regions_not_moscow_regions, :name => 'Билайн, Центральный регион, кроме домашнего' }}}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_50mb[:id])

#_sc_rouming_bln_exept_for_cenral_regions_not_moscow_regions, Internet
  category = {:uniq_service_category => 'own_country_regions/internet', 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Bln_all_russia_except_some_regions_for_internet, :name => 'Билайн, Все регионы  кроме регионов с ограниченным интернетом' }}}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_50mb[:id], :tarif_set_must_include_tarif_options => [_bln_30_days_of_internet_for_russia_rouming] )


@tc.add_tarif_class_categories


