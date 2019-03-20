@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_intra_countries_services, :name => 'Международные вызовы', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/mezhdunarodnaya-svyaz-i-rouming-postoplata/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )
  
#Own and home regions, Calls, Outcoming, to_bln_international_1 (СНГ, Грузия), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_1, :name => 'Билайн, услуги СНГ, Грузия телефоны Билалайн' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 12.0} } })

#Own and home regions, Calls, Outcoming, to_bln_international_2 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_2, :name => 'Билайн, услуги СНГ, Абхазия, Грузия и Южная Осетия на прочие телефоны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 24.0} } })

#Own and home regions, Calls, Outcoming, to_bln_international_3 (Европа (вкл. Турцию), США, Канада)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_3, :name => 'Билайн, услуги в Европу, США, Канаду' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })

#Own and home regions, Calls, Outcoming, to_bln_international_4 (Северная и Центральная Америка (без США и Канады))
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_4, :name => 'Билайн, услуги Северная и Центральная Америка (без США и Канады)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 40.0} } })

#Own and home regions, Calls, Outcoming, to_bln_international_5 (пока пустая)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_5, :name => 'Билайн, услуги в остальные страны - 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 55.0} } })

#Own and home regions, Calls, Outcoming, to_bln_international_6 (Остальные страны)
category = {:uniq_service_category => 'own_and_home_regions/calls_out/to_abroad_countries/to_operators', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_6, :name => 'Билайн, услуги в остальные страны - 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 55.0} } })



#Own and home regions, sms, Outcoming, to_bln_international_1 (СНГ, Грузия), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_1, :name => 'Билайн, услуги СНГ, Грузия телефоны Билалайн' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own and home regions, sms, Outcoming, to_bln_international_2 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_2, :name => 'Билайн, услуги СНГ, Абхазия, Грузия и Южная Осетия на прочие телефоны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own and home regions, sms, Outcoming, to_bln_international_3 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_3, :name => 'Билайн, услуги в Европу, США, Канаду' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own and home regions, sms, Outcoming, to_bln_international_4 (Северная и Центральная Америка (без США и Канады))
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_4, :name => 'Билайн, услуги Северная и Центральная Америка (без США и Канады)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own and home regions, sms, Outcoming, to_bln_international_5 (Азия)
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_5, :name => 'Билайн, услуги в остальные страны - 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })

#Own and home regions, sms, Outcoming, to_bln_international_6 (Остальные страны)
category = {:uniq_service_category => 'own_and_home_regions/sms_out/to_abroad', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_6, :name => 'Билайн, услуги в остальные страны - 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.95} } })


#Own and home regions, mms, Outcoming, to_bln_international_1 (СНГ, Грузия), телефоны Билайн
category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_1, :name => 'Билайн, услуги СНГ, Грузия телефоны Билалайн' }, :to_operators => {:in => Category::Operator::Const::BeelinePartnerOperators, :name => 'партнер оператора' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own and home regions, mms, Outcoming, to_bln_international_2 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_2, :name => 'Билайн, услуги СНГ, Абхазия, Грузия и Южная Осетия на прочие телефоны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own and home regions, mms, Outcoming, to_bln_international_3 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:uniq_service_category => 'own_and_home_regions/mms_out',  
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_3, :name => 'Билайн, услуги в Европу, США, Канаду' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own and home regions, mms, Outcoming, to_bln_international_4 (Северная и Центральная Америка (без США и Канады))
category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_4, :name => 'Билайн, услуги Северная и Центральная Америка (без США и Канады)' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own and home regions, mms, Outcoming, to_bln_international_5 (Азия)
category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_5, :name => 'Билайн, услуги в остальные страны - 1' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })

#Own and home regions, mms, Outcoming, to_bln_international_6 (Остальные страны)
category = {:uniq_service_category => 'own_and_home_regions/mms_out', 
  :filtr => {:to_abroad_countries => {:in => Category::Country::Bln::International_6, :name => 'Билайн, услуги в остальные страны - 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 7.95} } })




@tc.add_tarif_class_categories

