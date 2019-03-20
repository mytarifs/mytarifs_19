module SavableInSession::Modeble
  
  def create_modeble(model_class)
    modeble = Modeble.new(model_class)
    init_session_for_formable(modeble)
    set_session_from_params_for_modeble(modeble)
    modeble.model = model_class.new(session[:form][modeble.form_name])    
    modeble
  end
  
  def session_model_params(modeble)
    session[:form][modeble.form_name].dup
  end
  
  class Modeble
    include SavableInSession::AssistanceInView
    attr_accessor :form_name, :caption, :action_on_submit, :model
    
    def initialize(model_class)
      @base_name = model_class.name.underscore.gsub(/\//, "_").to_sym # || controller.model_name || controller.controller_path.gsub(/\//, "_").underscore.singularize.to_sym
      @form_name = "#{@base_name}"
    end
  end
end
