# == Schema Information
#
# Table name: service_categories
#
#  id        :integer          not null, primary key
#  name      :string
#  type_id   :integer
#  parent_id :integer
#  level     :integer
#  path      :integer          default([]), is an Array
#

require 'test_helper'

describe 'Service::Category' do
  before do
     Customer::Call.create(:base_subservice_id => 50,
      :own_phone => {"number" => "7000000000", "operator_id" => "1025", "region_id" =>"1501"},
      :partner_phone => {"number" => "79999999999", "operator_id"=>"1025", "region_id" => "1501"},
      :connect => {"operator_id" => "1025", "region_id" =>"1501"},
      :description => {"time" => "2014-01-01T10:00:13.000+00:00", "duration" => 30.270091687653668, "volume" => nil, "volume_unit_id" => nil}  
     )

    @cat = Service::Category.find(0)
    @fq_tarif_operator_id = Category::Operator::Const::Beeline
    @fq_tarif_region_id = _moscow
  end

  describe 'seed data' do
  end
  
  describe 'method where_hash' do
    it 'must exists' do
      Service::Category.new.must_respond_to(:where_hash)
    end 
    
  end
  

end
