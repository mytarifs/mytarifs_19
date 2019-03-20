@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_30_days_of_internet_for_russia_rouming, :name => '30 дней интернета для путешествий по России', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/30-dney/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {:internet_options => [_bln_highway_4, _bln_highway_8, _bln_highway_12, _bln_highway_20, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => { :to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


@tc.add_tarif_class_categories


