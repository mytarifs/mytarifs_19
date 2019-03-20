require 'test_helper'
#tarif_file_name = 'mts/tarifs/posekundny.rb'
#Dir[Rails.root.join("db/seeds/tarifs/#{tarif_file_name}")].each { |f| require f }
#Dir[Rails.root.join("db/seeds/tarif_tests/#{tarif_file_name}")].each { |f| require f }

describe TarifSeedTester do
  before do
    @tc = TarifCreator.new(Category::Operator::Const::Mts)
    @tc.create_tarif_class({
      :id => _mts_posekundny, :name => 'Посекудный', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _tarif,
      :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/second/'},
      :dependency => {
        :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
        :incompatibility => {}, #{group_name => [tarif_class_ids]}
        :general_priority => _gp_tarif_without_limits,
        :other_tarif_priority => {:lower => [], :higher => []},
        :prerequisites => [],
        :multiple_use => false,    
      } } )
  end

end

