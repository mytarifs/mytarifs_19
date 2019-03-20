module ServiceParser
  class Megafon
    class Legal::Tarif::CorporateUnlimited < ServiceParser::Megafon
      def page_special_action_steps
        return [] if !(tarif_class.name =~ /Корпоративный безлимит/i)
                
        calls_rouming_keys_selector = [
          "div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(1) > div.radio-button > label.radio-button__label",
        ]
        nodes_with_keys = check_and_return_all_nodes_with_scope(doc, calls_rouming_keys_selector) || []
        calls_rouming_keys = nodes_with_keys.map{|nodes_with_key| nodes_with_key.try(:text).try(:to_s).try(:squish)}#.reverse
        
        calls_rouming_keys = case
        when tarif_class.name =~ /поездками по России/i
          calls_rouming_keys.select{|calls_rouming_key| calls_rouming_key =~ /Поездки по России/i}
        when (!(tarif_class.name =~ /поездками по России/i) and (tarif_class.name =~ /Межгород/i))
          calls_rouming_keys.select{|calls_rouming_key| ((calls_rouming_key =~ /Межгород/i) and !(calls_rouming_key =~ /Поездки по России/i))}
        else
          calls_rouming_keys.select{|calls_rouming_key| (!(calls_rouming_key =~ /Межгород/i) and !(calls_rouming_key =~ /Поездки по России/i))}
        end

        calls_volume_keys_selector = [
          "div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(1) div.b-b2b-tariff-matrix-filters__rule span.b-b2b-tariff-matrix-filters__numb",
        ]
        nodes_with_keys = check_and_return_all_nodes_with_scope(doc, calls_volume_keys_selector) || []
        calls_volume_keys = nodes_with_keys.map{|nodes_with_key| nodes_with_key.try(:text).try(:squish)}

        internet_rouming_keys_selector = [
          "div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(2) > div.radio-button > label.radio-button__label",
        ]
        nodes_with_keys = check_and_return_all_nodes_with_scope(doc, internet_rouming_keys_selector) || []
        internet_rouming_keys = nodes_with_keys.map{|nodes_with_key| nodes_with_key.try(:text).try(:to_s).try(:squish)}

        internet_volume_keys_selector = [
          "div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(2) div.b-b2b-tariff-matrix-filters__rule span.b-b2b-tariff-matrix-filters__numb",
        ]
        nodes_with_keys = check_and_return_all_nodes_with_scope(doc, internet_volume_keys_selector) || []
        interent_volume_keys = nodes_with_keys.map{|nodes_with_key| nodes_with_key.try(:text).try(:squish)}
        
        my_title = Proc.new do |first_level_key, second_level_key, third_level_key, fourth_level_key|
          if second_level_key == calls_volume_keys[0] and third_level_key == internet_rouming_keys[0] and fourth_level_key == interent_volume_keys[0]
            "Базовый тариф #{[first_level_key, second_level_key, third_level_key, fourth_level_key]}"
          else
            additional_volumes = []
            additional_volumes << ((second_level_key.try(:to_i) || 0) - calls_volume_keys[0].try(:to_i))
            additional_volumes << (third_level_key.split(' + ')[1] || "")
            additional_volumes << ((fourth_level_key.try(:to_i) || 0) - interent_volume_keys[0].try(:to_i))
            "Дополнительные объемы #{additional_volumes}"
          end
        end
        
        [
          {
            :keys => calls_rouming_keys,
            :select => 
              {
                :scope => ["div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(1)"],
                :scope_visible => true,
                :element_tags => [
                  {:css => "div.radio-button > label.radio-button__label", :visible => true, :type => :find, :wait => 0.1},
                ],
                :use_key => true,
              },
          },
          {
            :keys => calls_volume_keys,
            :select => 
              {
                :scope => ["div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(1)"],
                :scope_visible => true,
                :element_tags => [
                  {:css => "div.b-b2b-tariff-matrix-filters__rule > span.b-b2b-tariff-matrix-filters__numb", :visible => true, :type => :find, :wait => 0.1},
                ],
                :use_key => true,
              },
          },
          {
            :keys => internet_rouming_keys,
            :select => 
              {
                :scope => ["div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(2)"],
                :scope_visible => true,
                :element_tags => [
                  {:css => "div.radio-button > label.radio-button__label", :visible => true, :type => :find, :wait => 0.1},
                ],
                :use_key => true,
              },
          },
          {
            :keys => interent_volume_keys,
            :select => 
              {
                :scope => ["div.b-b2b-tariff-matrix-filters__tab-content:nth-of-type(2)"],
                :scope_visible => true,
                :element_tags => [
                  {:css => "div.b-b2b-tariff-matrix-filters__rule > span.b-b2b-tariff-matrix-filters__numb", :visible => true, :type => :find, :wait => 0.1},
                ],
                :use_key => true,
              },
            :post_select => 
              {
                :scope => ["div.b-b2b-tariff-matrix-card__info"],
                :scope_visible => true,
                :element_tags => [
                  {:css => "div > a.b-b2b-tariff-matrix-card__more", :visible => true, :text => "Информация о тарифе", :type => :find, :wait => 0.1},
                ],
              },             
            :my_title => my_title,
            :scope_to_save_tags => ["div.d-tariff-remote"],
            :page_go_back_after_yield => true,
          },
        ]
      end 

      def service_parsing_tags
        {
         :base_service_scope => [],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.d-tariff-remote"],
             :block_name_tag => [" > my_title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["div.b-b2b-layout__content > div.b-b2b-text > table.tariff_remote_params > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "В абонентскую плату включено"},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['td:nth-of-type(1)',],
             :param_value_tag => ['td:nth-of-type(3)',],
           },
           {
             :block_tag => ["div.d-tariff-remote"],
             :block_name_tag => [" > my_title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["div.b-b2b-layout__content >  div.b-b2b-text > div.acc-section"],
             :sub_block_name_tag => [" > div.acc-header > h3"],
             
             :row_tag => [" > div.acc-subsection > table > tbody > tr"],
             :param_name_tag => ['td:nth-of-type(1)',],
             :param_value_tag => ['td:nth-of-type(3)',],
           },
         ]
        }
      end
    end
  end
end