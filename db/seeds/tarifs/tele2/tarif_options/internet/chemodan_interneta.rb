@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_chemodan_interneta, :name => 'Чемодан интернета', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/internet/dlya-telefonov/chemodan-interneta-3g4g/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :internet_options => [_tele_internet_from_phone, _tele_paket_interneta, _tele_portfel_interneta, _tele_chemodan_interneta, _tele_day_in_net]
    }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [ _tele_add_trafic_3gb, _tele_add_trafic_100mb, _tele_add_trafic_5gb]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_tele_black, _tele_very_black, _tele_most_black, _tele_mostest_black], :to_serve => []},
    :multiple_use => false
  } } )

#internet included in tarif
scg_tele_chemodan_interneta = @tc.add_service_category_group(
    {:name => 'scg_tele_chemodan_interneta' }, 
    {:name => "price for scg_tele_chemodan_interneta"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 30000.0, :price => 899.0}, :window_over => 'month' } } )

  #internet for scg_tele_add_trafic_100mb option
  scg_tele_add_trafic_100mb = @tc.add_service_category_group(
    {:name => 'scg_tele_add_trafic_100mb_tele_chemodan_interneta' }, 
    {:name => "price for scg_tele_add_trafic_100mb_tele_chemodan_interneta"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay, 
      :formula => {:params => {:max_sum_volume => 100.0, :price => 15.0} } }
    )

  #internet for scg_tele_add_trafic_3gb option
  scg_tele_add_trafic_3gb= @tc.add_service_category_group(
    {:name => 'scg_tele_add_trafic_3gb_tele_chemodan_interneta' }, 
    {:name => "price for scg_tele_add_trafic_3gb_tele_chemodan_interneta"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 3000.0, :price => 150.0} } }
    )
   
  #internet for scg_tele_add_trafic_5gb option
  scg_tele_add_trafic_5gb= @tc.add_service_category_group(
    {:name => 'scg_tele_add_trafic_5gb_tele_chemodan_interneta' }, 
    {:name => "price for scg_tele_add_trafic_5gb_tele_chemodan_interneta"}, 
    {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 5000.0, :price => 250.0} } }
    )
   
   #Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 0.0} } })  

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_chemodan_interneta[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_trafic_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_trafic_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_trafic_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_trafic_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_trafic_5gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_trafic_5gb] )

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_chemodan_interneta[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_trafic_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_trafic_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_trafic_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_trafic_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_trafic_5gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_trafic_5gb] )

@tc.add_tarif_class_categories
