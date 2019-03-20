module Optimization::Global
  class Base
    module Dictionary
      def self.tr(word)
        dictionary = {
          'rouming'.freeze => 'Роуминг'.freeze, 'service'.freeze => 'Услуга'.freeze, 'direction'.freeze => 'Направление связи'.freeze, 
          'geo'.freeze => 'Куда'.freeze, 'operator'.freeze => 'На какого оператора'.freeze, 
          'count'.freeze => 'Кол-во услуг'.freeze, 'sum duration'.freeze => 'Звонки, мин'.freeze, 'count volume'.freeze => 'СМС и ММС, шт'.freeze, 
          'sum volume'.freeze => 'Интернет, Мб'.freeze,
          'calls'.freeze => 'звонки'.freeze, 'sms'.freeze => 'смс'.freeze, 'mms'.freeze => 'ммс'.freeze, 'internet'.freeze => 'интернет'.freeze,
          'in'.freeze => 'входящие'.freeze, 'out'.freeze => 'исходящие'.freeze, 
          'own_home_regions'.freeze => 'собственный и домашний регион'.freeze, 'own_country'.freeze => 'Россия'.freeze, 'all_world'.freeze => 'за границей'.freeze,
          'to_not_rouming_country'.freeze => 'За пределы страны нахождения'.freeze, 'not_own_country'.freeze => 'за пределы России'.freeze,
          'to_russia'.freeze => 'в Россию'.freeze, 'europe'.freeze => 'в европу'.freeze,
          'own_operator'.freeze => 'на своего оператора'.freeze,  'not_own_operator'.freeze => 'на чужого оператора'.freeze,
          'fixed'.freeze => 'Постоянные оплаты'.freeze,

          'own_and_home_regions'.freeze => 'домашний регион'.freeze,
          'own_country_regions'.freeze => 'Россия'.freeze,
          'abroad_countries'.freeze => 'за границей'.freeze,

          'calls_in'.freeze => 'Вход. звонки'.freeze,
          'calls_out'.freeze => 'Исход. звонки'.freeze,
          'sms_in'.freeze => 'Вход. смс'.freeze,
          'sms_out'.freeze => 'Исход. смс'.freeze,
          'mms_in'.freeze => 'Вход. ммс'.freeze,
          'mms_out'.freeze => 'Исход. ммс'.freeze,
          'internet'.freeze => 'Интернет'.freeze,

          'to_own_and_home_regions'.freeze => 'в домашний регион'.freeze,
          'to_own_country_regions'.freeze => 'в регионы России'.freeze,
          'to_abroad_countries'.freeze => 'за пределы России'.freeze,
#          'to_abroad'.freeze => 'за пределы России'.freeze,
          
          'to_rouming_country'.freeze => 'В страну нахождения'.freeze, 
          'to_other_countries'.freeze => 'В прочие страны, кроме России и страны нахождения'.freeze, 

        }
        if word and dictionary[word.to_s]
          dictionary[word.to_s]
        else
          word
        end
      end
    end
  end
end
