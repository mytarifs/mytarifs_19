#Везде как дома Smart (for smart only)
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_everywhere_as_home_smart, :name => 'Везде как дома SMART', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/calls_across_russia/discounts/vkd_smart/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_internet],
    :incompatibility => {:everywhere_as_home => [_mts_everywhere_as_home, _mts_everywhere_as_home_Ultra, _mts_everywhere_as_home_smart]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [_mts_everywhere_as_home], :higher => []},
    :prerequisites => [_mts_smart_mini], #,_mts_smart, _mts_smart_plus, _mts_smart_top],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart_bezlimitishe], :to_serve => []},
    :multiple_use => false
  } } )

#задается в самих тарифах
=begin
#Добавление новых service_category_group for smart
  #calls included in tarif
  scg_mts_smart_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_calls"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 400.0, :price => 0.0}, :window_over => 'month' } }
    )

  #sms included in tarif
  scg_mts_smart_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 1000.0, :price => 0.0}, :window_over => 'month' } }
    )
  #internet included in tarif
  scg_mts_smart_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 1500.0, :price => 0.0}, :window_over => 'month' } }
    )
=end

#В этой опции задаются только категории, без формул расчета цены 
#Переход на тариф
#  @tc.add_only_service_category_tarif_class(_sctcg_one_time_tarif_switch_on)  

#Ежемесячная плата
#  @tc.add_only_service_category_tarif_class(_sctcg_periodic_monthly_fee)  
 
#Own country, Calls, incoming
  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Calls, Outcoming, to_own_home_regions, to_own_operator
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Calls, Outcoming, to_own_home_regions, to_not_own_operator
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Calls, Outcoming, to_own_country, to_own_operator
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_only_service_category_tarif_class(category)  

@tc.add_tarif_class_categories
