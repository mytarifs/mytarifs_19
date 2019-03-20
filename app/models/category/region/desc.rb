class Category  
  class Region::Desc
    c = Category::Region::Const 
    o = Category::Operator::Const
    f = Category::FederalRegion::Const

    attr_reader :region_id, :operator_id
    
    def initialize(region_id, operator_id)
      @region_id = region_id
      @operator_id = operator_id
    end
    
    def self.region_ids_ready_for_scraping
      Const.keys.select{|region_id| Const[region_id]['mobile_region_slug']}
    end
    
     def region_ids_by_region_types_or_region_ids(region_types_or_region_ids)
       result = []
       region_types_or_region_ids.each do |region_type_or_region_id|
         if region_type_or_region_id < 0
           result = (region_ids_by_region_type(region_type_or_region_id) - result)
         else
           result << region_type_or_region_id
         end         
       end
       result
     end
     
     def region_ids_by_region_type(region_type)
      c = Category::Region::Const
      case region_type
      when c::Own_region_id; [own_region_id];
      when c::Home_region_ids; home_region_ids;
      when c::Neighbour_home_region_ids; neighbour_home_region_ids;
      when c::Extended_home_region_ids; extended_home_region_ids;
      when c::Macro_region_ids; macro_region_ids;
      when c::Extended_macro_region_ids; extended_macro_regions_ids;
      when c::Good_internet_region_ids; [];
      when c::Bad_internet_region_ids; [];
      when c::Special_rouming_region_ids; special_rouming_region_ids;
      when c::Own_country_region_ids; [];
      else []
      end
    end
    
    def own_region_id
      region_id
    end
    
    def home_region_ids
      Const[region_id]['home_region_ids'][operator_id]
    end
    
    def own_and_home_region_ids
      [own_region_id] + home_region_ids
    end
    
    def neighbour_home_region_ids
      Const[region_id]['neighbour_home_region_ids'][operator_id]
    end
    
    def extended_home_region_ids
      Const[region_id]['extended_home_region_ids'][operator_id] - own_and_home_region_ids
    end
    
    def macro_region_ids
      Const[region_id]['macro_region_ids'][operator_id] - own_and_home_region_ids - extended_home_region_ids
    end
    
    def extended_macro_regions_ids
      Const[region_id]['extended_macro_regions_ids'][operator_id] - own_and_home_region_ids - extended_home_region_ids - macro_region_ids
    end
    
    def mobile_region_name
      Const[region_id]['mobile_region_name'][operator_id]
    end
    
    def special_rouming_region_ids
      c = Category::Region::Const
      [c::Respublika_krym, c::Simferopol, c::Sevastopol, ]
    end
    
    def subdomain
      Const[region_id]['subdomain'][operator_id]
    end
    
    def substitute_names
      Const[region_id]['substitute_names'][operator_id]
    end
    
    Const = {
    c::Abakan => {
      'mobile_region_slug' => 'khakasia', 
      'home_region_ids' => {o::Mts => [c::Respublika_hakasiya], 
        o::Tele2 => [c::Respublika_tyva_tuva, c::Kyzyl, c::Respublika_hakasiya, c::Krasnoyarskii_krai, c::Krasnoyarsk], 
        o::Megafon => [c::Respublika_hakasiya], o::Beeline => [c::Respublika_hakasiya]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], 
        o::Beeline => f[:sibirsky][:region_ids] - [c::Respublika_buryatiya, c::Ulan_ude, c::Zabaikalskii_krai, c::Chita, c::Irkutsk, c::Irkutskaya_oblast]},
      'macro_region_ids' => {o::Mts => f[:sibirsky][:region_ids], o::Tele2 => f[:sibirsky][:region_ids], o::Megafon => f[:sibirsky][:region_ids], o::Beeline => f[:sibirsky][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Хакасия (Республика Хакасия) — Абакан', o::Tele2 => 'Республики Хакасия и Тыва', o::Megafon => 'Республика Хакасия', o::Beeline => 'Республика Хакасия'},
      'substitute_names' => {
        o::Mts => {
          'по Красноярскому краю, Республикам Хакасия, Тыва' => 'по домашнему региону',
          'по Республики Хакасия, Тыва и Красноярскому краю' => 'по домашнему региону',
          'в республиках Хакасия, Тыва и Красноярском крае' => 'в домашнем регионе',
          'на территории Республик Хакасия, Тыва и Красноярского края' => 'на территории домашнего региона',
          'Республик Хакасия, Тыва и Красноярского края' => 'домашнего региона',
          'Республики Хакасия и Тыва, Красноярский край \(за исключением Таймырского Долгано-Ненецкого муниципального района и г. Норильск\)' => 'домашний регион',
          'Республики Хакасия, Тыва и Красноярского края' => 'домашнего региона',
          'республики Хакасия' => 'домашнего региона',
          'Республика Хакасия, Тыва и Красноярский край \(за исключением Таймырского Долгано-Ненецкого муниципального района и г. Норильск\)' => 'домашний регион',
          'Хакасия [(]Республика Хакасия[)] — Абакан' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в республиках Хакасия и Тыва, Красноярском крае' => 'в домашнем регионе',
          'республик Хакасия и Тыва, Красноярского края' => 'домашнего региона',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'республик Хакасия, Тыва и Красноярского края' => 'домашнего региона',
          'республик Хакасия' => 'по домашнему региону',
          'на территории Сибири' => 'на территории расширенного домашнего региона',
        },
      },
      'subdomain' => {o::Mts => 'khakasia', o::Tele2 => 'khakasia', o::Megafon => 'hakas', o::Beeline => 'abakan'}},
    c::Novosibirsk => {
      'mobile_region_slug' => 'novosibirsk_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Novosibirskaya_oblast], o::Tele2 => [c::Novosibirskaya_oblast], o::Megafon => [c::Novosibirskaya_oblast], o::Beeline => [c::Novosibirskaya_oblast]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'macro_region_ids' => {o::Mts => f[:sibirsky][:region_ids], o::Tele2 => f[:sibirsky][:region_ids], o::Megafon => f[:sibirsky][:region_ids], o::Beeline => f[:sibirsky][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Новосибирская область', o::Tele2 => 'Новосибирская область', o::Megafon => 'Новосибирская область', o::Beeline => 'Новосибирск'},
      'substitute_names' => {
        o::Mts => {
          'в г. Новосибирск и Новосибирской области' => 'в домашнем регионе', 
          'по г. Новосибирск и Новосибирской области' => 'по домашнему региону', 
          'по г. Новосибирску и Новосибирской области' => 'по домашнему региону', 
          'г. Новосибирска и Новосибирской области' => 'домашнего региона', 
          'на территории г. Новосибирск и Новосибирской области' => 'на территории домашнего региона', 
          'г. Новосибирск и Новосибирской области' => 'домашнего региона', 
          'Новосибирской области' => 'домашнего региона',
          'г. Новосибирски Новосибирскаяобласть' => 'домашний регион',
          'г. Новосибирск и Новосибирская область' => 'домашний регион',
          'г.Новосибирск и Новосибирск обл.' => 'домашний регион',
          'Новосибирская область' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Новосибирской области' => 'в домашнем регионе',
          'Новосибирска и Новосибирской области' => 'домашнего региона',
          'Новосибирской области' => 'домашнего региона',
          'Новосибирска' => 'домашнего региона',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'по Новосибирску и области' => 'по домашнему региону', 
        },
      },
      'subdomain' => {o::Mts => 'nsk', o::Tele2 => 'novosibirsk', o::Megafon => 'nsk', o::Beeline => 'novosibirsk'}}, 
    c::Krasnoyarsk => {
      'mobile_region_slug' => 'krasnoyarsk_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Krasnoyarskii_krai], 
        o::Tele2 => [c::Krasnoyarskii_krai, c::Respublika_tyva_tuva, c::Kyzyl, c::Respublika_hakasiya, c::Abakan], 
        o::Megafon => [c::Krasnoyarskii_krai], o::Beeline => [c::Krasnoyarskii_krai]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'macro_region_ids' => {o::Mts => f[:sibirsky][:region_ids], o::Tele2 => f[:sibirsky][:region_ids], o::Megafon => f[:sibirsky][:region_ids], o::Beeline => f[:sibirsky][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Красноярский край — Красноярск', o::Tele2 => 'Красноярский край (кроме Норильска)', o::Megafon => 'Красноярский край', o::Beeline => 'Красноярск'},
      'substitute_names' => {
        o::Mts => {
          'в Красноярском крае, республиках Тыва и Хакасия' => 'в домашнем регионе',
          'в Красноярском крае, республиках Тыва, Хакасия' => 'в домашнем регионе',
          'по Красноярскому краю, Республик Хакасия и Тыва' => 'по домашнему региону',
          'по Красноярскому краю, Республикам Хакасия и Тыва' => 'по домашнему региону',
          'по Красноярскому краю, Республикам Хакасия, Тыва' => 'по домашнему региону',
          'на территории Красноярского края, Республик Хакасия и Тыва' => 'на территории домашнего региона',
          'на территории Красноярского края, Республик Тыва, Хакасия' => 'на территории домашнего региона',
          'Красноярского края, Республик Тыва, Хакасия' => 'домашнего региона',
          'Красноярского края, Республик Хакасия и Тыва' => 'домашнего региона',
          'Красноярского края' => 'домашнего региона',
#          'республики Хакасия' => 'домашнего региона',
          'Красноярский край — Красноярск' => 'домашний регион',
          'Красноярский край \(за исключением Таймырского Долгано-Ненецкого муниципального района и г. Норильск\), Республики Хакасия и Тыва' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Красноярском крае, республиках Хакасия и Тыва' => 'в домашнем регионе',
          'Красноярского края, республик Хакасия и Тыва' => 'домашнего региона',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'Красноярского края, республик Хакасия и Тыва' => 'домашнего региона',
          'на территории Сибири' => 'на территории расширенного домашнего региона',
        },
      },
      'subdomain' => {o::Mts => 'kras', o::Tele2 => 'krasnoyarsk', o::Megafon => 'kras', o::Beeline => 'krasnoyarsk'}}, 
    c::Alaniya => {
      'mobile_region_slug' => 'alania',  
      'home_region_ids' => {o::Mts => [c::Respublika_severnaya_osetiya], o::Tele2 => [c::Respublika_severnaya_osetiya], o::Megafon => [c::Respublika_severnaya_osetiya], o::Beeline => [c::Respublika_severnaya_osetiya]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => f[:north_kaukas][:region_ids] - [c::Stavropol, c::Stavropolskii_krai], o::Tele2 => [], o::Megafon => [], 
        o::Beeline => f[:north_kaukas][:region_ids] + [c::Respublika_adygeya, c::Maikop, c::Krasnodarskii_krai, c::Krasnodar, c::Rostovskaya_oblast, c::Rostov]
      },
      'macro_region_ids' => {o::Mts => f[:north_kaukas][:region_ids], o::Tele2 => f[:north_kaukas][:region_ids], o::Megafon => f[:north_kaukas][:region_ids], o::Beeline => []}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => f[:sourth][:region_ids]},
      'mobile_region_name' => {o::Mts => 'Алания (Республика Северная Осетия - Алания), Владикавказ', o::Tele2 => nil, o::Megafon => 'Республика Северная Осетия', o::Beeline => 'Республика Северная Осетия'},
      'substitute_names' => {
        o::Mts => {
          'Республика Северная Осетия-Алания, Республика Дагестан, Республика Ингушетия, Республика Кабардино-Балкария, Республика Карачаево-Черкессия, Чеченская Республика, Ставропольский край' => 'расширенный домашний регион',
          'в г. Владикавказ и Республики Северная Осетия - Алания' => 'в домашнем регионе',
          'на территории г. Владикавказ и Республики Северная Осетия - Алания' => 'на территории домашнего региона',
          'на территории Республики Северная Осетия - Алания' => 'на территории домашнего региона',
          'по Республике Северная Осетия-Алания' => 'по домашнему региону',
          'по Республике Северная Осетия — Алания' => 'по домашнему региону',
          'Республики Северная Осетия - Алания' => 'домашнего региона',
          'Республики Северная Осетия — Алания' => 'домашнего региона',
          'Республики Северная Осетия' => 'домашнего региона',
          'Алания [(]Республика Северная Осетия - Алания[)], Владикавказ' => 'домашний регион',
          'Ставропольский край, Республика Северная Осетия-Алания, Республика Дагестан, Республика Кабардино-Балкария, Республика Карачаево-Черкессия, Республика Ингушетия, Чеченская Республика' => 'макро регион',
        }, 
        o::Tele2 => {}, 
        o::Megafon => {}, 
        o::Beeline => {
          'Республики Северная Осетия' => 'домашнего региона',
          'по Югу и Кавказу' => 'по расширенному домашнему региону', 
        },
      },
      'subdomain' => {o::Mts => 'alania', o::Tele2 => nil, o::Megafon => 'alania', o::Beeline => 'severnaya-osetiya'}}, 
    c::Moskva => {
      'mobile_region_slug' => 'moskva_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Moskovskaya_oblast], o::Tele2 => [c::Moskovskaya_oblast], o::Megafon => [c::Moskovskaya_oblast], o::Beeline => [c::Moskovskaya_oblast]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'macro_region_ids' => {o::Mts => f[:central][:region_ids], o::Tele2 => f[:central][:region_ids], o::Megafon => f[:central][:region_ids], o::Beeline => f[:central][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Москва и Подмосковье', o::Tele2 => 'Москва и Московская область', o::Megafon => 'Москва и область', o::Beeline => 'Москва'},
      'substitute_names' => {
        o::Mts => {
          'по г. Москве и Московской области' => 'по домашнему региону',
          'по г.Москве и Московской области' => 'по домашнему региону',
          'г. Москвы и Московской области' => 'домашнего региона',
          'на территории Москвы и Московской области' => 'на территории домашнего региона',
          'Москвы и Московской области' => 'домашнего региона',
          'Москвы' => 'домашнего региона',
          'Москва, Московская область' => 'домашний регион',
          'г. Москва и Московская обл.' => 'домашний регион',
          'Москва и Подмосковье' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Москве и Московской области' => 'в домашнем регионе',
          'Москвы и Московской области' => 'домашнего региона',
          'Москвы и Московской обл.' => 'домашнего региона',
        }, 
        o::Megafon => {
          'Московского региона' => 'домашнего региона',
        }, 
        o::Beeline => {
          'по Москве и области' => 'по домашнему региону',
          'г. Москвы и области' => 'по домашнему региону',
          'Москвы и области' => 'по домашнему региону',
          'Московского региона' => 'по домашнему региону',
          'г. Москвы и московской области' => 'по домашнему региону',
          'Москвы и московской области' => 'по домашнему региону',
          'в Московской области' => 'в домашнем регионе',
        },
      },
      'subdomain' => {o::Mts => '', o::Tele2 => 'msk', o::Megafon => 'moscow', o::Beeline => 'moskva'}}, 
    c::Sankt_peterburg => {
      'mobile_region_slug' => 'sankt_peterburg_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Leningradskaya_oblast], o::Tele2 => [c::Leningradskaya_oblast], o::Megafon => [c::Leningradskaya_oblast], o::Beeline => [c::Leningradskaya_oblast]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'macro_region_ids' => {o::Mts => f[:north_west][:region_ids], o::Tele2 => f[:north_west][:region_ids], o::Megafon => f[:north_west][:region_ids], o::Beeline => f[:north_west][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Санкт-Петербург, Ленинградская область', o::Tele2 => 'Санкт-Петербург и Ленинградская область', o::Megafon => 'Санкт-Петербург и область', o::Beeline => 'Санкт-Петербург'},
      'substitute_names' => {
        o::Mts => {
          'по г. Санкт-Петербургу и Ленинградской области' => 'по домашнему региону',
          'по Санкт-Петербургу и Ленинградской области' => 'по домашнему региону',
          'в Санкт-Петербурге и Ленинградской области' => 'в домашнем регионе',
          'на территории Санкт-Петербурга и Ленинградской области' => 'на территории домашнего региона',
          'на территории г. Санкт-Петербург и Ленинградской области' => 'на территории домашнего региона',
          'г.Санкт-Петербурга и Ленинградской области' => 'домашнего региона',
          'г. Санкт-Петербурга и Ленинградской области' => 'домашнего региона',
          'Санкт-Петербурга и Ленинградской области' => 'домашнего региона',
          'г. Санкт-Петербург и Ленинградская область' => 'домашний регион',
          'Санкт-Петербург и Ленинградская область' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Санкт-Петребурге и Ленинградской области' => 'в домашнем регионе',
          'Санкт-Петербурга и Ленинградской области' => 'домашнего региона',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'г. Санкт-Петербурга и Ленинградской области' => 'домашнего региона',
          'Санкт-Петербурга и Ленинградской области' => 'домашнего региона',
          'по Санкт-Петербургу и Ленинградской области' => 'по домашнему региону',
        },
      },
      'subdomain' => {o::Mts => 'spb', o::Tele2 => 'spb', o::Megafon => 'spb', o::Beeline => 'spb'}}, 
    c::Ekaterinburg => {
      'mobile_region_slug' => 'ekaterinburg_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Sverdlovskaya_oblast], o::Tele2 => [c::Sverdlovskaya_oblast], o::Megafon => [c::Sverdlovskaya_oblast], o::Beeline => [c::Sverdlovskaya_oblast]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'macro_region_ids' => {o::Mts => f[:uralsky][:region_ids], o::Tele2 => f[:uralsky][:region_ids], o::Megafon => f[:uralsky][:region_ids], o::Beeline => f[:uralsky][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Свердловская область — Екатеринбург', o::Tele2 => 'Свердловская область', o::Megafon => 'Свердловская область', o::Beeline => 'Екатеринбург'},
      'substitute_names' => {
        o::Mts => {
          'по г. Екатеринбургу и Свердловской области' => 'по домашнему региону',
          'в Свердловской области' => 'в домашнем регионе',
          'г. Екатеринбурга и Свердловской области' => 'домашнего региона',
          'Екатеринбурга и Свердловской области' => 'домашнего региона',
          'Свердловской области' => 'домашнего региона',
          'Свердловская область — Екатеринбург' => 'домашний регион',
          'Свердловская область' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Свердловской области' => 'в домашнем регионе',
          'Свердловской области' => 'домашнего региона',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'г. Екатеринбурга и Свердловской области' => 'домашнего региона',
          'Екатеринбурга и Свердловской области' => 'домашнего региона',
          'Свердловской области' => 'домашнего региона',
        },
      },
      'subdomain' => {o::Mts => 'e-burg', o::Tele2 => 'ekt', o::Megafon => 'svr', o::Beeline => 'ekaterinburg'}}, 
    c::Nizhnii_novgorod => {
      'mobile_region_slug' => 'nizhnii_novgorod_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Nizhegorodskaya_oblast], o::Tele2 => [c::Nizhegorodskaya_oblast], o::Megafon => [c::Nizhegorodskaya_oblast], o::Beeline => [c::Nizhegorodskaya_oblast]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [c::Moskva, c::Moskovskaya_oblast], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'macro_region_ids' => {o::Mts => f[:near_volgsky][:region_ids], o::Tele2 => f[:near_volgsky][:region_ids], o::Megafon => f[:near_volgsky][:region_ids], o::Beeline => f[:near_volgsky][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Нижегородская область — Нижний Новгород', o::Tele2 => 'Нижегородская область', o::Megafon => 'Н.Новгород и область', o::Beeline => 'Нижний Новгород'},
      'substitute_names' => {
        o::Mts => {
          'в Нижегородской области' => 'в домашнем регионе', 
          'в г. Нижний Новгород и Нижегородской области' => 'в домашнем регионе', 
          'на территории г. Нижний Новгород и Нижегородской области' => 'на территории домашнего региона', 
          'на территории Нижегородской области' => 'на территории домашнего региона', 
          'Нижнего Новгорода и Нижегородской области' => 'домашнего региона', 
          'по Нижегородской области' => 'по домашнему региону', 
          'Нижегородской области' => 'домашнего региона', 
          'г. Нижний Новгород, Нижегородская область' => 'домашний регион',
          'Нижегородская область — Нижний Новгород' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Нижегородской области' => 'в домашнем регионе', 
          'Нижегородская область' => 'домашнего региона',
          'Нижегородской области' => 'домашнего региона', 
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'Нижнего Новгорода и области' => 'домашнего региона', 
          'Нижегородской области' => 'домашнего региона', 
        },
      },
      'subdomain' => {o::Mts => 'nnov', o::Tele2 => 'nnov', o::Megafon => 'nn', o::Beeline => 'nizhniy-novgorod'}}, 
    c::Samara => {
      'mobile_region_slug' => 'samara_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Samarskaya_oblast], o::Tele2 => [c::Samarskaya_oblast], o::Megafon => [c::Samarskaya_oblast], o::Beeline => [c::Samarskaya_oblast]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'macro_region_ids' => {o::Mts => f[:near_volgsky][:region_ids], o::Tele2 => f[:near_volgsky][:region_ids], o::Megafon => f[:near_volgsky][:region_ids], o::Beeline => f[:near_volgsky][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Самарская область', o::Tele2 => 'Самарская область', o::Megafon => 'Самарская область', o::Beeline => 'Самара'},
      'substitute_names' => {
        o::Mts => {
          'по г. Самара и Самарской области' => 'по домашнему региону',
          'в Самарской области' => 'в домашнем регионе',
          'Самары и Самарской области' => 'домашнего региона',
          'по Самарской области' => 'по домашнему региону',
          'Самарской области' => 'домашнего региона',
          'г. Самара, Самарская область' => 'домашний регион',
          'Самара, Самарская область' => 'домашний регион',
          'Самарская область' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Самарской области' => 'в домашнем регионе',
          'Самарской области' => 'домашнего региона',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'г. Самары и Самарской области' => 'домашнего региона',
          'Самарской области' => 'домашнего региона',
        },
      },
      'subdomain' => {o::Mts => 'samara', o::Tele2 => 'samara', o::Megafon => 'samara', o::Beeline => 'samara'}}, 
    c::Rostov => {
      'mobile_region_slug' => 'rostov_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Rostovskaya_oblast], o::Tele2 => [c::Rostovskaya_oblast], o::Megafon => [c::Rostovskaya_oblast], o::Beeline => [c::Rostovskaya_oblast]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [c::Krasnodar, c::Krasnodarskii_krai, c::Respublika_adygeya, c::Maikop], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], 
        o::Beeline => f[:north_kaukas][:region_ids] + [c::Respublika_adygeya, c::Maikop, c::Krasnodarskii_krai, c::Krasnodar, c::Rostovskaya_oblast, c::Rostov]
      },
      'macro_region_ids' => {o::Mts => f[:sourth][:region_ids], o::Tele2 => f[:sourth][:region_ids], o::Megafon => f[:sourth][:region_ids], o::Beeline => f[:sourth][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Ростовская область — Ростов-на-Дону', o::Tele2 => 'Ростовская область', o::Megafon => 'Ростовская область', o::Beeline => 'Ростов-на-Дону'},
      'substitute_names' => {
        o::Mts => {
          'в Ростовской области' => 'в домашнем регионе',
          'по Ростовской области' => 'по домашнему региону',
          'на территории Ростовской области' => 'на территории домашнего региона',
          'в г. Ростов-на-Дону и Ростовской области' => 'в домашнем регионе', 
          'Ростова-на-Дону и Ростовской области' => 'домашнего региона',
          'Ростовской области' => 'домашнего региона',
          'Ростовская область — Ростов-на-Дону' => 'домашний регион',
          'Ростовская область' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Ростовской области' => 'в домашнем регионе',
          'Ростовской области' => 'домашнего региона',
          'Краснодарского края и Республики Адыгея' => 'соседних регионов',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'Ростовской области' => 'домашнего региона',
          'по Югу и Кавказу' => 'по расширенному домашнему региону', 
        },
      },
      'subdomain' => {o::Mts => 'rnd', o::Tele2 => 'rostov', o::Megafon => 'rostov', o::Beeline => 'rostov-na-donu'}}, 
    c::Krasnodar => {
      'mobile_region_slug' => 'krasnodar_i_oblast', 
      'home_region_ids' => {o::Mts => [c::Krasnodarskii_krai], o::Tele2 => [c::Krasnodarskii_krai], o::Megafon => [c::Krasnodarskii_krai], o::Beeline => [c::Krasnodarskii_krai]},
      'neighbour_home_region_ids' => {o::Mts => [], o::Tele2 => [c::Rostov, c::Rostovskaya_oblast], o::Megafon => [], o::Beeline => []},
      'extended_home_region_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], 
        o::Beeline => f[:north_kaukas][:region_ids] + [c::Respublika_adygeya, c::Maikop, c::Krasnodarskii_krai, c::Krasnodar, c::Rostovskaya_oblast, c::Rostov]
      },
      'macro_region_ids' => {o::Mts => f[:sourth][:region_ids], o::Tele2 => f[:sourth][:region_ids], o::Megafon => f[:sourth][:region_ids], o::Beeline => f[:sourth][:region_ids]}, 
      'extended_macro_regions_ids' => {o::Mts => [], o::Tele2 => [], o::Megafon => [], o::Beeline => []},
      'mobile_region_name' => {o::Mts => 'Краснодарский край и Республика Адыгея', o::Tele2 => 'Краснодарский край и Республика Адыгея', o::Megafon => 'Краснодарский край', o::Beeline => 'Краснодар'},
      'substitute_names' => {
        o::Mts => {
          'в Краснодарском крае и Республике Адыгея' => 'в домашнем регионе',
          'на территории Краснодарского края и Республики Адыгея' => 'на территории домашнего региона',
          'по Краснодарскому краю и Республике Адыгея' => 'по домашнему региону',
          'Краснодарского края и Республики Адыгея' => 'домашнего региона',
          'Краснодарский край и Республика Адыгея' => 'домашний регион',
        }, 
        o::Tele2 => {
          'в Краснодарском крае и Республике Адыгея' => 'в домашнем регионе',
          'Краснодарского края и Республики Адыгея' => 'домашнего региона',
          'Краснодарского края и Адыгеи' => 'домашнего региона',
          'Ростовской области' => 'соседних регионов',
        }, 
        o::Megafon => {}, 
        o::Beeline => {
          'Краснодарского края и Республики Адыгея' => 'домашнего региона',
          'Краснодарского края' => 'домашнего региона',
          'по Югу и Кавказу' => 'по расширенному домашнему региону', 
        },
      },
      'subdomain' => {o::Mts => 'kuban', o::Tele2 => 'krasnodar', o::Megafon => 'krasnodar', o::Beeline => 'krasnodar'}}, 

    c::Anadyr => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Arhangelsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Astrahan => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Barnaul => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Belgorod => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Birobidzhan => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Blagoveschensk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Bryansk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Velikii_novgorod => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Vladivostok => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Vladimir => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Volgograd => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Vologda => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Voronezh => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Groznyi => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Ivanovo => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Irkutsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Izhevsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Ioshkar_ola => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kazan => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kaliningrad => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kaluga => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kemerovo => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kirov => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kostroma => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kurgan => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kursk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Kyzyl => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Lipetsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Magadan => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Magas => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Maikop => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Mahachkala => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Murmansk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Nalchik => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Omsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Orenburg => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Orel => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Penza => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Petrozavodsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Petropavlovsk_kamchatskii => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Perm => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Pskov => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Ryazan => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Salehard => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Saransk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Saratov => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Smolensk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Mineralnye_vody => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Syktyvkar => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Tambov => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Tver => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Tomsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Tula => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Tumen => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Ulan_ude => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Ulyanovsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Ufa => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Habarovsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Cheboksary => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Chelyabinsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Cherkessk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Chita => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Elista => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Ugra => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Uzhno_sahalinsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Yakutsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Yaroslavl => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Vladikavkaz => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Gorno_altaisk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Stavropol => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}}, 
    c::Sevastopol => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}},  
    c::Simferopol => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}},  
    c::Pyatigorsk => {'subdomain' => {o::Mts => nil, o::Tele2 => nil, o::Megafon => nil, o::Beeline => nil}},  
    }
  end
  
end