@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_the_best_rouming, :name => 'Самый выгодный роуминг', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/samiy-vigodniy-rouming/?editing=true',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

  #calls included in tarif
  scg_bln_all_for_the_best_rouming_calls_1 = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_the_best_rouming_calls_1' }, 
    {:name => "price for scg_bln_all_for_the_best_rouming_calls_1"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed,  
      :formula => {:params => {:max_duration_minute => 10.0, :price => 100.0}, :window_over => 'day' } }
    )
  #calls included in tarif
  scg_bln_all_for_the_best_rouming_calls_2 = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_the_best_rouming_calls_2' }, 
    {:name => "price for scg_bln_all_for_the_best_rouming_calls_2"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed,  
      :formula => {:params => {:max_duration_minute => 20.0, :price => 200.0}, :window_over => 'day' } }
    )

#bln_the_best_internet_in_rouming_1, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_1[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_1, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_1[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_1, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1 , :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ'}}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_1[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_1, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1 , :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ'}}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_1[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_1, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#bln_the_best_internet_in_rouming_1, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_1, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#bln_the_best_internet_in_rouming_1, mms, outcoming
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.95} } })  

#bln_the_best_internet_in_rouming_1, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 40.0, :price => 200.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 5.0} } })  





#bln_the_best_internet_in_rouming_2, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_2[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_2, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_2[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_2, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_2[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_2, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_the_best_rouming_calls_2[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_2, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#bln_the_best_internet_in_rouming_2, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 10.0} } })  

#bln_the_best_internet_in_rouming_2, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#bln_the_best_internet_in_rouming_2, mms, outcoming
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.95} } })  

#bln_the_best_internet_in_rouming_2, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 40.0, :price => 200.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 5.0} } })  




#bln_the_best_internet_in_rouming_3, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#bln_the_best_internet_in_rouming_3, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 100.0} } })  

#bln_the_best_internet_in_rouming_3, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 100.0} } })  

#bln_the_best_internet_in_rouming_3, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 100.0} } })  

#bln_the_best_internet_in_rouming_3, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#bln_the_best_internet_in_rouming_3, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#bln_the_best_internet_in_rouming_3, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#bln_the_best_internet_in_rouming_3, mms, outcoming
category = {:uniq_service_category => 'abroad_countries/mms_out',  
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.95} } })  

#bln_the_best_internet_in_rouming_3, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_3, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 90.0} } })  



#bln_the_best_internet_in_rouming_4, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#bln_the_best_internet_in_rouming_4, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#bln_the_best_internet_in_rouming_4, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#bln_the_best_internet_in_rouming_4, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#bln_the_best_internet_in_rouming_4, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#bln_the_best_internet_in_rouming_4, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 29.0} } })  

#bln_the_best_internet_in_rouming_4, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#bln_the_best_internet_in_rouming_4, mms, outcoming
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 14.95} } })  

#bln_the_best_internet_in_rouming_4, Internet
category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_4, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", экзотические страны, где услуга не действует' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })  


@tc.add_tarif_class_categories


