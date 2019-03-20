module Category::FederalRegion
  c = Category::Region::Const
  Const = {
    :central => {:name => 'Центральный ФО', :full_name => 'Центральный федеральный округ', :city_id => c::Moskva, :region_ids => [
      c::Belgorod, c::Belgorodskaya_oblast, c::Bryansk, c::Bryanskaya_oblast, c::Vladimir, c::Vladimirskaya_oblast, c::Voronezh, c::Voronezhskaya_oblast,
      c::Ivanovo, c::Ivanovskaya_oblast, c::Kaluga, c::Kaluzhskaya_oblast, c::Kostroma, c::Kostromskaya_oblast, c::Kursk, c::Kurskaya_oblast, 
      c::Lipetsk, c::Lipetskaya_oblast, c::Moskva, c::Moskovskaya_oblast, c::Orel, c::Orlovskaya_oblast, c::Ryazan, c::Ryazanskaya_oblast,
      c::Smolensk, c::Smolenskaya_oblast, c::Tambov, c::Tambovskaya_oblast, c::Tver, c::Tverskaya_oblast, c::Tula, c::Tulskaya_oblast, c::Yaroslavl, c::Yaroslavskaya_oblast
      ]
    },
    :north_west => {:name => 'Северо-Западный ФО', :full_name => 'Северо-Западный федеральный округ', :city_id => c::Sankt_peterburg, :region_ids => [
      c::Respublika_kareliya, c::Petrozavodsk, c::Respublika_komi, c::Syktyvkar, c::Arhangelsk, c::Arhangelskaya_oblast, c::Vologda, c::Vologodskaya_oblast,
      c::Kaliningrad, c::Kaliningradskaya_oblast, c::Leningradskaya_oblast, c::Sankt_peterburg, c::Murmansk, c::Murmanskaya_oblast, c::Novgorodskaya_oblast, c::Velikii_novgorod,
      c::Pskov, c::Pskovskaya_oblast
      ]
    },
    :sourth => {:name => 'Южный ФО', :full_name => 'Южный федеральный округ', :city_id => c::Rostov, :region_ids => [
      c::Respublika_adygeya, c::Maikop, c::Respublika_kalmykiya, c::Elista, c::Krasnodar, c::Krasnodarskii_krai, c::Respublika_krym, c::Simferopol, c::Sevastopol,
      c::Astrahan, c::Astrahanskaya_oblast, c::Volgograd, c::Volgogradskaya_oblast, c::Rostov, c::Rostovskaya_oblast
      ]
    },
    :north_kaukas => {:name => 'Северо-Кавказский ФО', :full_name => 'Северо-Кавказский федеральный округ', :city_id => c::Pyatigorsk, :region_ids => [
      c::Respublika_dagestan, c::Mahachkala, c::Respublika_ingushetiya, c::Magas, c::Respublika_kabardino_balkariya, c::Nalchik, c::Respublika_karachaevo_cherkesiya, c::Cherkessk,
      c::Respublika_severnaya_osetiya, c::Vladikavkaz, c::Chechenskaya_respublika, c::Groznyi, c::Stavropol, c::Stavropolskii_krai
      ]
    },
    :near_volgsky => {:name => 'Приволжский ФО', :full_name => 'Приволжский федеральный округ', :city_id => c::Nizhnii_novgorod, :region_ids => [
      c::Respublika_bashkortostan, c::Ufa, c::Respublika_marii_el, c::Ioshkar_ola, c::Respublika_mordoviya, c::Saransk, c::Respublika_tatarstan, c::Kazan, 
      c::Respublika_udmurtiya, c::Izhevsk, c::Chuvashskaya_respublika, c::Cheboksary, c::Kirov, c::Kirovskaya_oblast, c::Nizhegorodskaya_oblast, c::Nizhnii_novgorod,
      c::Orenburg, c::Orenburgskaya_oblast, c::Penza, c::Penzenskaya_oblast, c::Samara, c::Samarskaya_oblast, c::Saratov, c::Saratovskaya_oblast,
      c::Ulyanovsk, c::Ulyanovskaya_oblast, c::Perm, c::Permskii_krai
      ]
    },
    :uralsky => {:name => 'Уральский ФО', :full_name => 'Уральский федеральный округ', :city_id => c::Ekaterinburg, :region_ids => [
      c::Kurgan, c::Kurganskaya_oblast, c::Sverdlovskaya_oblast, c::Ekaterinburg, c::Tumen, c::Tumenskaya_oblast, c::Chelyabinsk, c::Chelyabinskaya_oblast,
      c::Hanty_mansiiskii_avtonomnyi_okrug, c::Ugra, c::Yamalo_nenetskii_avtonomnyi_okrug, c::Salehard, 
      ]
    },
    :sibirsky => {:name => 'Сибирский ФО', :full_name => 'Сибирский федеральный округ', :city_id => c::Novosibirsk, :region_ids => [
      c::Respublika_altai, c::Gorno_altaisk, c::Respublika_buryatiya, c::Ulan_ude, c::Respublika_tyva_tuva, c::Kyzyl, c::Respublika_hakasiya, c::Abakan, 
      c::Altaiskii_krai, c::Barnaul, c::Zabaikalskii_krai, c::Chita, c::Krasnoyarskii_krai, c::Krasnoyarsk, c::Irkutsk, c::Irkutskaya_oblast,
      c::Kemerovo, c::Kemerovskaya_oblast, c::Novosibirsk, c::Novosibirskaya_oblast, c::Omsk, c::Omskaya_oblast, c::Tomsk, c::Tomskaya_oblast
      ]
    },
    :far_east => {:name => 'Дальневосточный ФО', :full_name => 'Дальневосточный федеральный округ', :city_id => c::Habarovsk, :region_ids => [
      c::Respublika_saha_yakutiya, c::Yakutsk, c::Kamchatskii_krai, c::Petropavlovsk_kamchatskii, c::Primorskii_krai, c::Vladivostok, 
      c::Habarovskii_krai, c::Habarovsk, c::Amurskaya_oblast, c::Blagoveschensk, c::Magadan, c::Magadanskaya_oblast, c::Sahalinskaya_oblast, c::Uzhno_sahalinsk,
      c::Evreiskaya_avtonomnaya_oblast, c::Birobidzhan, c::Chukotskii_avtonomnyi_okrug, c::Anadyr
      ]
    },
  }

    
end

