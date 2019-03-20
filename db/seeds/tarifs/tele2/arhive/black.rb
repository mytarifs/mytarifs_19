@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_black_04_2016, :name => 'Черный 04_2016', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {
    :http => 'http://msk.tele2.ru/tariff/black/', 
    :buy_http => 'http://msk.shop.tele2.ru/products/choose_tariff/_gv/tariff-id_10659',
    :phone_number_type => ["Федеральный"],
    :payment_type => "Предоплатная",
    :phone_must_have_3g_or_4g => true,
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],    
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :is_archived => true,
    :multiple_use => false
  } } )
  
#Добавление новых service_category_group

  #sms included in tarif
  scg_tele_black_04_2016_sms = @tc.add_service_category_group(
    {:name => 'scg_tele_black_04_2016_sms' }, 
    {:name => "price for scg_tele_black_04_2016_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 150.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet included in tarif
  scg_tele_black_04_2016_internet = @tc.add_service_category_group(
    {:name => 'scg_tele_black_04_2016_internet' }, 
    {:name => "price for scg_tele_black_04_2016_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 2000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet for scg_tele_add_speed_100mb option
  scg_tele_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_100mb_tele_black_04_2016' }, 
    {:name => "price for scg_tele_add_speed_100mb_tele_black_04_2016"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay, 
      :formula => {:params => {:max_sum_volume => 100.0, :price => 15.0} } }
    )

  #internet for scg_tele_add_speed_3gb option
  scg_tele_add_speed_3gb= @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_3gb_tele_black_04_2016' }, 
    {:name => "price for scg_tele_add_speed_3gb_tele_black_04_2016"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 3000.0, :price => 150.0} } }
    )

  #internet for scg_tele_add_speed_5gb option
  scg_tele_add_speed_5gb= @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_5gb_tele_tele_black_04_2016' }, 
    {:name => "price for scg_tele_add_speed_5gb_tele_tele_black_04_2016"}, 
    {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 5000.0, :price => 250.0} } }
    )
   

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 99.0} } })

  
#Own and home regions, Calls, Incoming
category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.5} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.5} } })


#Own and home regions, sms, incoming
category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_black_04_2016_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.5} } })

#Own and home regions, sms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.5} } })


#Own and home regions, mms, incoming
category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })

#Own and home regions, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_black_04_2016_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_5gb] )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 4,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 0.16} } })  #как в опции Добавить скорость плюс 1 копейка


#Own country, mms, incoming
category = {:uniq_service_category => 'own_country_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own country, mms, Outcoming, to_own_home_regions
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })

#Own country, mms, Outcoming, to_own country
category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })

#Own country, mms, outcoming, to not Russia
  category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_black_04_2016_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_5gb] )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 4,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 0.16} } })  #как в опции Добавить скорость плюс 1 копейка



@tc.add_tarif_class_categories

