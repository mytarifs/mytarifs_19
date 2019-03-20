#TODO добавить 50 руб в день в роуминге по России
#Интернет-VIP
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_internet_vip, :name => 'Интернет-VIP', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/tarifu/unlim_options/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
      :internet_comp => [_mts_mini_bit, _mts_bit, _mts_super_bit, _mts_additional_internet_500_mb, _mts_additional_internet_1_gb, 
        _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip], 
      :internet_smart => [_mts_additional_internet_500_mb, _mts_additional_internet_1_gb, _mts_super_bit]},
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_mts_mini_bit], :higher => [_mts_turbo_button_100_mb, _mts_turbo_button_500_mb, _mts_turbo_button_1_gb, _mts_turbo_button_2_gb, _mts_turbo_button_5_gb]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart_bezlimitishe], :to_serve => []}, #:to_switch_on => [_mts_smart, _mts_smart_mini, _mts_smart_plus, _mts_ultra, _mts_mts_connect_4, _mts_smart_top], :to_serve => []},
    :multiple_use => false
  } } )

  #internet included in tarif
  scg_mts_internet_vip_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_internet_vip_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_internet_vip_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 30000.0, :price => 1200.0}, :window_over => 'month' } } )

#auto_turbo_buttons 
  #internet for add_speed_500mb option
  scg_mts_add_speed_500mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_500mb_mts_internet_vip' }, 
    {:name => "price for scg_mts_add_speed_500mb_mts_internet_vip"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 500.0, :price => 95.0} } }
    )

  #internet for add_speed_1gb option
  scg_mts_add_speed_1gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_1gb_mts_internet_vip' }, 
    {:name => "price for scg_mts_add_speed_1gb_mts_internet_vip"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 175.0} } }
    )

  #internet for add_speed_2gb option
  scg_mts_add_speed_2gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_2gb_mts_internet_vip' }, 
    {:name => "price for scg_mts_add_speed_2gb_mts_internet_vip"}, 
    {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 2000.0, :price => 300.0} } }
    )

  #internet for add_speed_5gb option
  scg_mts_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_5gb_mts_internet_vip' }, 
    {:name => "price for scg_mts_add_speed_5gb_mts_internet_vip"}, 
    {:calculation_order => 4, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 5000.0, :price => 450.0} } }
    )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })

#_own_and_home_regions_rouming, internet
category = {:uniq_service_category => 'own_and_home_regions/internet',}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_internet_vip_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_1_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )

#All Russia rouming, internet, with turbo-buttons
category = {:uniq_service_category => 'own_country_regions/internet',}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_internet_vip_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_1_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )

@tc.add_tarif_class_categories

#есть описание в pdf
#турбо-кнопки добавлены в опцию, а не отдельно
#TODO не добавлена кнопка "Турбо-ночи"
