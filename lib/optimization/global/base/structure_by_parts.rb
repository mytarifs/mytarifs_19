module Optimization::Global
  class Base
    StructureByParts = {
      'own-country-rouming/calls' => {
        :own_and_home_regions => {
          :calls_in => {},
          :calls_out => {
            :to_own_and_home_regions => {:to_operators => {}},
            :to_own_country_regions => {:to_operators => {}},
            :to_abroad_countries => {:to_operators => {}}
          },
        },
        :own_country_regions => {
          :calls_in => {:to_operators => {}},
          :calls_out => {
            :to_own_and_home_regions => {:to_operators => {}},
            :to_own_country_regions => {:to_operators => {}},
            :to_abroad_countries => {:to_operators => {}}
          },
        },
      },
      'own-country-rouming/sms' => {
        :own_and_home_regions => {
          :sms_in => {},
          :sms_out => {:to_own_and_home_regions => {}, :to_own_country_regions => {}, :to_abroad_countries => {}}, #:to_abroad => {}},
        },
        :own_country_regions => {
          :sms_in => {},
          :sms_out => {:to_own_and_home_regions => {}, :to_own_country_regions => {}, :to_abroad_countries => {}}, #:to_abroad => {}},
        },        
      },
      'own-country-rouming/mms' => {
        :own_and_home_regions => {
          :mms_in => {},
          :mms_out => {},
        },
        :own_country_regions => {
          :mms_in => {},
          :mms_out => {},
        },        
      },
      'own-country-rouming/mobile-connection' => {
        :own_and_home_regions => {
          :internet =>{}
        },
        :own_country_regions => {
          :internet =>{}
        },
        
      },
      'all-world-rouming/calls' => {
        :abroad_countries => {
            :calls_in => {},
            :calls_out => {:to_russia => {}, :to_rouming_country => {}, :to_other_countries => {}},
        }
      },
      'all-world-rouming/sms' => {
        :abroad_countries => {
            :sms_in => {},
            :sms_out => {},
        }
      },
      'all-world-rouming/mms' => {
        :abroad_countries => {
            :mms_in => {},
            :mms_out => {},
        }
      },
      'all-world-rouming/mobile-connection' => {
        :abroad_countries => {
            :internet =>{}
        }
      },
    } 
    
  end    
end
