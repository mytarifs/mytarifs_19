module Cpanet 
  class Runner
    extend RunnerGeneralHelper
    
    def self.init(orginal_options)
      options = my_deep_symbolize!(orginal_options)
      class_name = base_class_string(options[:cpanet])
      class_name.constantize.new(options)
    end
    
    #Cpanet::Runner.test
    def self.test
      if false
        net = 'admitad'
        offer = 1350
      else
        net = 'actionpay'
        offer = 4554
      end
      options = {
        'cpanet' => net,
        'website_id' => Cpanet::Website.where(:cpanet => net).first,
        'offer_id' => offer,
        'clean_cache' => 'true1',
        'show_only_command_keys' => 'true',
        'file_url' => 'http://cn.actionpay.ru/s/j-33ZOX6xZR6Kqfx0ETgPA/yml/yml970.xml?key=rSCsHskGO160QZpR',
      }
      result = Runner.init(options).parsed_catalog
      result
    end
    
    def self.run_command_with_background(command, options)
      if options['calculate_on_background'] == 'true'
        ::CpanetSynchronize.perform_async(command, options)
        number_of_workers_to_add = 1
#        start_background_workers(options, number_of_workers_to_add) 
      else
        send(command, options)
      end      
    end
    
    def self.synchronize_my_offer(options)
      cpanet = Cpanet::Runner.init(options)
      my_offers_from_net = cpanet.my_offers
      
      return {:alert => "error in #{options[:cpanet]}, #{my_offers_from_net}" } if cpanet.processed_result_has_error?(my_offers_from_net)

      Cpanet::MyOffer.synchronize_my_offers(options[:website_id], my_offers_from_net)
    end
    
    def self.synchronize_offer(options)
      cpanet = Cpanet::Runner.init(options)
      offer_from_net = cpanet.offer
      
      return {:alert => "error in #{options[:cpanet]}, #{offer_from_net}" } if cpanet.processed_result_has_error?(offer_from_net)

      Cpanet::Offer.synchronize_offer(options[:cpanet], options[:offer_id], offer_from_net)
    end
    
    def self.synchronize_catalog(options)
      cpanet = Cpanet::Runner.init(options)
      catalogs = cpanet.catalogs
      
      return {:alert => "error in #{options[:cpanet]}, #{catalogs}" } if cpanet.processed_result_has_error?(catalogs)

      my_offer_to_update = Cpanet::MyOffer.where(:id => options[:my_offer_id]).first
      Cpanet::MyOffer.synchronize_catalogs(my_offer_to_update, catalogs)
    end
    
    def self.base_class_string(cpanet)
      case cpanet
      when 'admitad'; "Cpanet::Base::Admitad";
      when 'actionpay'; "Cpanet::Base::Actionpay";
      when 'mytarifs'; "Cpanet::Base::Mytarifs";
      else
      end
    end

  end

end