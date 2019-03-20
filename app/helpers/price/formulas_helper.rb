module Price::FormulasHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::SessionInitializers

  def price_list
    return @price_list if @price_list
    @price_list = PriceList.find(params['price_list_id'].try(&:to_i) || price_formula.try(:price_list_id)) if params['price_list_id'] or price_formula.try(:price_list_id)  
  end
  
  def price_formula
    return @price_formula if @price_formula
    params[:id] = (params[:current_id].try(:[], 'formula_id') || session[:current_id].try(:[], 'formula_id')).try(:to_i) if action_name == 'index' and params[:id].blank?

    @price_formula = if params[:id] 
      Price::Formula.find(params[:id])
    else  
      Price::Formula.new
    end
 end
  
  def price_index_filtr
    create_filtrable("price_index")
  end
  
  def price_formulas
    filtr = session_filtr_params(price_index_filtr)
    model = Price::Formula.includes(:standard_formula).where({:price_list_id => params['price_list_id']})
    chosen_regions = (filtr['regions'] || []) - ['']
    model = model.where(model.regions_sql(chosen_regions, filtr['regions_filtr_type'])) if !chosen_regions.blank?

    options = {:base_name => 'price_formulas', :current_id_name => 'formula_id', :id_name => 'id', :pagination_per_page => 100}
    create_tableable(model, options)
  end

  def price_formula_form
    create_formable(price_formula)
  end  
    

  def check_price_formula_params_before_update
    if params["price_formula"]
      params["price_formula"]['calculation_order'] = nil if params["price_formula"]['calculation_order'].blank?
      params["price_formula"]['standard_formula_id'] = nil if params["price_formula"]['standard_formula_id'].blank?
      
      params["price_formula"]['formula'] ||= {}
      params["price_formula"]['formula']['params'] ||= {}
      Price::Formula.all_possible_formula_params_keys.each do |param_key|
        if params["price_formula"]['formula']['params'][param_key].blank?
          params["price_formula"]['formula']['params'].extract!(param_key)
        else
          params["price_formula"]['formula']['params'][param_key] = if param_key =~ /minute/
            params["price_formula"]['formula']['params'][param_key].try(:to_i)
          else
            params["price_formula"]['formula']['params'][param_key].try(:to_f)
          end
        end
      end
      
      params["price_formula"]['formula']['regions'] = ((params["price_formula"]['formula']['regions'] || []) - ['']).map(&:to_i)
      params["price_formula"]['formula'].extract!('regions') if params["price_formula"]['formula']['regions'].blank?

      params["price_formula"]['formula'].extract!('window_over') if params["price_formula"]['formula']['window_over'].blank?
    end
  end
  
  def check_price_formula_params_before_save
    params["price_formula"]['formula'] ||= {}
    params["price_formula"]['formula']['params'] ||= {}
    params_to_be_filled = (Price::StandardFormula::Const::ParamsByFormula[params["price_formula"]['standard_formula_id'].try(:to_i)].try(:[], 'params') || {})
    case 
    when params["price_formula"]['calculation_order'].blank?
      [false, "calculation_order cannot be blank"]
    when params["price_formula"]['standard_formula_id'].blank?
      [false, "standard_formula_id cannot be blank"]
    when (params_to_be_filled - params["price_formula"]['formula']['params'].keys).size > 0
      [false, "#{(params_to_be_filled - params["price_formula"]['formula']['params'].keys)} cannot be blank"]
    else
      [true, ""]
    end
  end
  
  
end
