@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_internet_on_day_100_mb, :name => 'Интернет на день 100 Мб', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/internet-na-den-100mb/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :internet_options => [_bln_highway_1, _bln_highway_4, _bln_highway_8, _bln_highway_12, _bln_highway_20, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb],
#      :add_speed_internet_options => [_bln_add_speed_1gb, _bln_add_speed_3gb, _bln_auto_add_speed, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb] 
      }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {
      :to_switch_on => 
        [_bln_all_for_300, _bln_all_for_500, _bln_all_for_800, _bln_all_for_1200, _bln_all_for_1800, 
      _bln_all_for_500_post, _bln_all_for_800_post, _bln_all_for_1200_post, _bln_all_for_1800_post, _bln_total_all_post], 
       :to_serve => []},
    :multiple_use => false
  } } )

#Добавление новых service_category_group
#internet included in tarif
scg_bln_internet_on_day_100_mb = @tc.add_service_category_group(
    {:name => 'scg_bln_internet_on_day_100_mb' }, 
    {:name => "price for scg_bln_internet_on_day_100_mb"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 100.0, :price => 19.0}, :window_over => 'day' } } )


#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_internet_on_day_100_mb[:id])

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_internet_on_day_100_mb[:id])



@tc.add_tarif_class_categories


