module ServiceParser
  class Beeline
    class Personal::AllTarifs::Planshet < ServiceParser::Beeline::Personal::AllTarifs
      def page_preview_action_tags
        [
          {
            :scope => ["div[class*=ProductsCatalog_devices]"],
            :element_tags => [{:css => 'span', :text => "планшет", :visible => true, :type => :find}],
          }
        ]
      end
      
    end
    
  end
   
end