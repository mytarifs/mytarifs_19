#Единая страна
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_single_country, :name => 'Единая страна', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/n_roaming/discounts/all_country/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms],
    :incompatibility => {:single_country => [_mts_single_country, _mts_everywhere_as_home]}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [_mts_smart_bezlimitishe, _mts_smart, _mts_smart_mini, _mts_smart_plus, _mts_ultra, _mts_smart_top, _mts_smart_nonstop], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Own country, calls, incoming, from own operator
  category = {:uniq_service_category => 'own_country_regions/calls_in/to_operators', 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })  

@tc.add_tarif_class_categories

#Тарификация поминутная, с округлением до целых минут в большую сторону

#В Ямало-Ненецком, Ханты-Мансийском АО, Пермском крае, Волгоградской и Пензенской областях кроме сети МТС, действуют сети операторов-партнеров.
#При выборе их сетей действуют следующие тарифы:
#– Все входящие вызовы и исходящие на номера России – 17 руб./мин.
#– Исходящие вызовы в другие страны СНГ – 38 руб./мин.
#– Исходящие вызовы в прочие страны – 129 руб./мин.
#– Исходящие SMS – 4,5 руб.
#– Входящие SMS – 0 руб.
#– GPRS – 8,6 руб. за 40 кб
#Скидки и опции в сетях других операторов не действуют.

# Доступ к услугам контент-провайдеров в роуминге посредством SMS на короткие номера, оплачивается по тарифу, действующему в "домашнем" регионе, плюс 3.95 руб.