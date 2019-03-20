module ServiceParser
  class Beeline
    class Personal::AllTarifs::Usbmodem < ServiceParser::Beeline::Personal::AllTarifs
      def page_preview_action_tags
        [
          {
            :scope => ["div[class*=ProductsCatalog_devices]"],
            :element_tags => [{:css => 'span', :text => "usb-модем", :visible => true, :type => :find}],
          }
        ]
      end
      
    end
    
  end
   
end