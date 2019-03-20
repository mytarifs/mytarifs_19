#Супер МТС
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_super_mts, :name => 'Супер МТС', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {
    :http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/supermts/', 
    :buy_http => 'http://shop.mts.ru/tariff/redirect.php?ID=1432591&regionId=1826',
    :phone_number_type => ["Федеральный", "Городской"],
    :payment_type => "Предоплатная",
    :allowed_option_for_children => true,
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],    
    },
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_super_mts_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_super_mts_included_in_tarif_calls' }, 
    {:name => "price for scg_mts_super_mts_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 20.0, :price => 0.0}, :window_over => 'day' } }
    )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, mms, Incoming
  category = {:uniq_service_category => 'own_and_home_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

  category = {:uniq_service_category => 'own_country_regions/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, mms, Outcoming
  category = {:uniq_service_category => 'own_and_home_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  

  category = {:uniq_service_category => 'own_country_regions/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  

#All_world_rouming, mms, Incoming
  category = {:uniq_service_category => 'abroad_countries/mms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_world_rouming, mms, Outcoming
  category = {:uniq_service_category => 'abroad_countries/mms_out',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  


#Own and home regions, calls, incoming
  category = {:uniq_service_category => 'own_and_home_regions/calls_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#Own and home regions, calls, outcoming, to_own_and_home_region, to_own_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_super_mts_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.5} } })

#Own and home regions, calls, outcoming, to_own_and_home_region, to_fixed_line
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::FixedlineOperator] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_super_mts_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, calls, outcoming, to_own_and_home_region, to_other_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts, Category::Operator::Const::FixedlineOperator] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, calls, outcoming, to_own_country, to_own_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators',  
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })

#Own and home regions, calls, outcoming, to_own_country, to_not_own_operator
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })

#Own and home regions, calls, outcoming, to_sic_country
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС' }}} 
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })

#Own and home regions, Calls, 0utcoming, to_europe
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'услуги в Европу МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })

#Own and home regions, calls, outcoming, to_other_country
  category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Other_countries, :name => 'услуги в прочие страны МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 70.0} } })

#Own and home regions, sms, incoming
  category = {:uniq_service_category => 'own_and_home_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, outcoming, to_own_home_regions
  category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_and_home_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.0} } })

#Own and home regions, sms, outcoming, to_own_country
  category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_own_country_regions',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.8} } })

#Own and home regions, sms, outcoming, to_not_own_country
  category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.25} } })

#Own country, сalls, incoming
  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.9} } })

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга

#Own country, Calls, Outcoming, to_own_country, to_not_own_operator
 category = {:uniq_service_category => 'own_country_regions/calls_out/to_own_country_regions/to_operators', 
  :filtr => {:to_operators => {:not_in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 14.0} } })

#Own country, Calls, Outcoming, to_sic_country
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС' }}} 
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 29.0} } })

#Own country, Calls, Outcoming, to_europe
  category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'услуги в Европу МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })

#Own country, Calls, Outcoming, to_other_country
 category = {:uniq_service_category => 'own_country_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Mts::Other_countries, :name => 'услуги в прочие страны МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 70.0} } })

#Own country, sms, Incoming
  category = {:uniq_service_category => 'own_country_regions/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All world, sms, Incoming
  category = {:uniq_service_category => 'abroad_countries/sms_in',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.9} } })

#Own and home regions, wap-internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeKByte, :formula => {:params => {:price => 2.75} } })

#Tarif option MMS+ (discount 50%)
#Другие mms категории должны иметь мешьший приоритет, или не пересекаться с опцией

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 34.0} } },
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 34.0} } },
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#_all_russia_rouming, mms, outcoming, to all own country regions, to own operator
  category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.25} } },
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

  category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.25} } },
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

  category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.25} } },
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

  category = {:uniq_service_category => 'own_country_regions/mms_out', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.25} } },
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#enf_of MMS+

@tc.add_tarif_class_categories

#есть pdf file