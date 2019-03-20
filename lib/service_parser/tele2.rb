module ServiceParser
   
  class Tele2 < Base
    
    def service_to_global_category_attributes
      {
        :tarif_payments => {
          :fixed_payment => [/абонентская плата/i, ],
          :onetime_payment => [/подключен/i, ],
          :tarification_period => [/Тип тарификации/i, ],
          :payment_type => [/Система расчетов/i, ],
          :phone_number_type => [/Тип номера/i, ],
        },
        :included_in_tarif => {
          :tarif_scope => [/тариф действует|действует на территории/i, ],
          :neighbour_home_region => [/В зону соседние регионы (теле2 |tele2 |)входят/i, ],
          :included_in_tarif => [
            /в абонентскую плату включено|Включено в абонентскую плату/i, 
            /пакеты минут и sms|пакет минут|пакет интернета|пакет sms/i, 
          ]
        },
        :blank_param_value_substitutes => {
          [/Безлимитные звонки/i, /Бесплатный трафик/i, /Бесплатные звонки/i, /бесплатно/i] => "0 руб",
          [/Безлимитно/i, ] => "100 ГБ",
        },          
        :split_params => {
          :param_name => {
            :scope => /wwww/i,
            :scope_join => "wwww",
            :scope_part => /;/i,
            :words_to_exclude_from_first_scope => []
          }
        },
        :service_direction => {
          :incoming => [/входящ/i, ],
          :outcoming => [/(?=.*(исходящ))(?!.*(входящ))(^.*$)/i, ]
        },
        :rouming => {
          :own_and_home_regions => [/в домашнем/i],
          :own_country_regions => [/в поездках по России/i],
          :abroad_countries => [/(зарубежом|за границ|в поездках по миру)/i],
        },      
        :service_type => {
          :incoming => {
            :calls_in => [/(?=.*(звонк|вызов))(?!.*(sms|смс|mms|ммс))(^.*$)/i,],
            :sms_in => [/(?=.*(sms|смс|сообщения))(?!.*(звонк|вызов|mms|ммс))(^.*$)/i],
            :mms_in => [/(?=.*(mms|ммс))(?!.*(звонк|вызов|sms|смс))(^.*$)/i, ],
            :internet => [/(internet|2g|3g|4g|gprs|интернет)/i, ],
          },
          :outcoming => {
            :calls_out => [/(?=.*(звонк|вызов))(?!.*(sms|смс|mms|ммс))(^.*$)/i, /(?=.*(пакет(ы) минут))(^.*$)/i,],
            :sms_out => [/(?=.*(sms|смс|сообщения))(?!.*(звонк|вызов|mms|ммс))(^.*$)/i],
            :mms_out => [/(?=.*(mms|ммс))(?!.*(звонк|вызов|sms|смс))(^.*$)/i, ],
            :internet => [/(internet|2g|3g|4g|gprs|интернет)/i, ],
          },
          :multiple_incoming => {
            :sms_in => [],
            :mms_in => [],
          },
          :multiple_outcoming => {
            :calls_out => [],
            :sms_out => [],
            :mms_out => [],
          },
        },
        :service_destination => {
          :russia_rouming => {
            :to_own_and_home_regions => [
              /на (все |остальные |)(мобильные |)(номера |телефоны |)(теле2 |tele2 |)домашнего/i, 
              /а все мобильные и городские телефоны домашнего региона/i, 
              /на все телефоны России/i, 
              /На номера (Теле2|Tele2) Россия/i,
              /На номера внутри сети/i,
              /по региону/i,
              /безлимитные звонки на телефоны Tele2 России/i,
              /SMS на телефоны всех мобильных операторов России/i,
              /SMS на телефоны мобильных операторов домашнего региона/i,
              /SMS на телефоны всех мобильных операторов домашнего региона/i,
              /SMS на номера любых сотовых операторов России/i,
            ],
            :to_extended_home_regions => [
              /соседних регионов/i,
            ],
            :to_own_country_regions => [
              /других регионов/i,
              /на (все |)(остальные |)(номера|телефоны) России/i,
              /(На|и) (все |остальные |)номера (Теле2|Tele2) Россия/i,
              /На номера внутри сети/i,
              /на телефоны Tele2 России/i,
              /SMS по России/i,
              /SMS на (номера|телефоны) (всех |любых )(мобильных |сотовых )операторов России/i,
              /SMS на номера домашнего региона и Tele2 Россия/i,
            ],
            :to_abroad_countries => [
              /(в другие стран|международных мобильных операторов|на телефоны других стран)/i,
              /(?=.*(Стоимость звонков в))(?!.*(регион).*)/i,
            ],
          },
          :abroad_rouming => {
            :to_russia => [/ццц/i],
            :to_rouming_country => [/ццц/i],
            :to_other_countries => [/ццц/i],
          },
        },
        :partner_type => {
          :to_operators => {
            :to_own_operator => [
              /(на (все |остальные |)(номера |телефоны |))(теле2|tele2|внутри сети)/i,
              /SMS на номера домашнего региона и Tele2 Россия/i,
            ],
            :to_all_operator => [
              /на все (мобильные и городские |)телефоны/i,
              /на телефоны соседних регионов/i,
              /на все (номера|телефоны) домашнего региона/i,
              /на все (номера|телефоны) России/i,
              /на (все |)мобильные телефоны|мобильных операторов/i,
              /SMS на (номера|телефоны) (всех |любых )(мобильных |сотовых )операторов России/i,
              /SMS на номера домашнего региона$/i,
       ],
            :to_other_operator => [
              /^(на (все |)остальные (номера|телефоны))/i,
              /^На остальные (номера|телефоны) (домашнего региона|России)/i,
              /Звонки на остальные телефоны домашнего региона/i,
            ],
            :to_other_mobile_operator => [/^на (остальные |)мобильные телефоны|^мобильных операторов/i],
            :to_fixed_line_operator => [/(фиксиров)/i],
          },
          :chosen_phone_number => {
            :to_favorite_numbers => [/на (выбранны|любимы)(й|е) номер/i],
            :to_contract_numbers => [/внутри компании/i],
            :to_tarif_numbers => [/ццц/i],
            :to_chosen_regions => [/ццц/i],
            :to_chosen_cities => [/ццц/i],
          },
        },
      }
    end
    
    def modal_tags
      [
        {
          :scope => [".sb-tv"],
          :element_tags => [
            {:css => 'span.sb-tv__close', :visible => true},
          ],
        },
        {
          :scope => [".modal"],
          :element_tags => [{:css => 'a', :text => "Понятно", :visible => true}, {:css => 'a', :text => "Нет, спасибо", :visible => true}],
        },
        {
          :scope => [".modal__text"],
          :element_tags => [{:css => 'a', :text => "Нет, спасибо", :visible => true}],
        },
      ]
    end
    
    def choose_region_tags
      {
        :scope => [".region-selector__question"],
        :element_tags => [{:css => 'a', :text => "Да", :visible => true, :type => :find}],
      }
    end
    
    def error_404_tags
      [["h1:contains('Страница не найдена')"]]
    end
    
    def fixed_month_payment_tags
      ["tr:contains('Абонентская плата') > td:nth-child(2)", "dl:contains('Абонентская плата') > dd"]
    end

    def fixed_day_payment_tags
      ["tr:contains('Абонентская плата в') > td:nth-child(2)", "dl:contains('Абонентская плата в') > dd"]
    end

    def service_tags
      [['.b-tariff', '.b-heading', '.page']]
    end
    
    def possibele_tags_to_exclude_from_page
      ['.region-selector__question', '.header', '.footer', '.b-menu']
    end
    
    def excluded_words_for_service_search
      []
    end

    def service_parsing_tags
      {
       :base_service_scope => [],
       :additional_service_scope => [],
       :service_blocks => [
         {
           :block_tag => [],
           :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [],
             :param_name_tag => [],
             :param_value_tag => [],
         }
       ]
      }
    end
  end

end