module FastOptimization::Data

  InputData = {
    :only_own_home_region => {
      :description => {
        :about_params => "Длительность звонков и количество смс включает как входящие, так и исходящие звонки и сообщения.",
        :about_optimization_assumptions => "Рекомендация по оптимальному тарифу и опциям рассчитаны при нахождении в домашнем регионе, звонках и смс только\
        в пределах домашнего региона."
      },
      :call_generation => {
        :general => {
    #    "phone_usage_type_id"=>243, 
          "share_of_time_in_own_region"=>1.0, 
          "share_of_time_in_home_region"=>0.0, 
          "share_of_time_in_own_country"=>0.0, 
          "share_of_time_abroad"=>0.0
        },
        :geo_calls => {
          "share_of_regional_calls"=>0.0, 
          "share_of_international_calls"=>0.0,         
        },
        :quantity => {
          'own-country-rouming/calls' => {
            "number_of_day_calls" => [1.0, 4.0, 10.0, 30.0, 50.0, ] ,            
          },
          'own-country-rouming/sms' => {
            "number_of_sms_per_day" => [1.0, 5.0, 10.0],
          },
          'own-country-rouming/mobile-connection' => {
            "internet_trafic_per_month" => [0.1, 0.5, 1.0, 5.0, 10.0, 30.0, ] ,      
          },
        },      
      },
      :optimization_type => {
        :id => 4,
        :name => "",
        :for_service_categories => {:country_roming => true, :intern_roming => false, :mms => false, :internet => true},
        :for_services_by_operator => [:country_rouming, :calls, :sms, :internet],
      },
      :optimization => {
        :id => 6,
        :name => "Данные для быстрого подбора тарифов для домашнего региона",
        :description => "",
        :publication_status_id => 100, 
        :publication_order => 1000, 
        :optimization_type_id => 4,
      },
    },
  }
  InputRegionData = {
    'personal' => {
      'khakasia' => {:optimization_id => 10},
      'novosibirsk_i_oblast' => {:optimization_id => 11},
      'krasnoyarsk_i_oblast' => {:optimization_id => 8},
      'alania' => {:optimization_id => 9},
      'moskva_i_oblast' => {:optimization_id => 6},
      'sankt_peterburg_i_oblast' => {:optimization_id => 7},
      'ekaterinburg_i_oblast' => {:optimization_id => 12},
      'nizhnii_novgorod_i_oblast' => {:optimization_id => 13},
      'samara_i_oblast' => {:optimization_id => 14},
      'rostov_i_oblast' => {:optimization_id => 15},
      'krasnodar_i_oblast' => {:optimization_id => 16},
    },
    'business' => {
      'khakasia' => {:optimization_id => 110},
      'novosibirsk_i_oblast' => {:optimization_id => 111},
      'krasnoyarsk_i_oblast' => {:optimization_id => 108},
      'alania' => {:optimization_id => 109},
      'moskva_i_oblast' => {:optimization_id => 106},
      'sankt_peterburg_i_oblast' => {:optimization_id => 107},
      'ekaterinburg_i_oblast' => {:optimization_id => 112},
      'nizhnii_novgorod_i_oblast' => {:optimization_id => 113},
      'samara_i_oblast' => {:optimization_id => 114},
      'rostov_i_oblast' => {:optimization_id => 115},
      'krasnodar_i_oblast' => {:optimization_id => 116},
    }
  }
  
  CalculationMethods = ['update_or_create_records_in_all_optimization_tables', 'calculate_temp_variable_result', 'calculate_temp_fixed_result', 
    'calculate_final_tarif_results', 'test']

end

