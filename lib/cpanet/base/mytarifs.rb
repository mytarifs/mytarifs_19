module Cpanet
  class Base::Mytarifs < Base
    
    Default = {
      :param_matches => {},
    }

    def run_command(command)
      case command
      when :websites
        [{
          'id' => 10,
          'name' => 'mytarifs',
          'status' => 'active',
        }]
      else
        [{}]
      end
    end
    
    def default
      Base::Mytarifs::Default
    end
    
  end
  
end