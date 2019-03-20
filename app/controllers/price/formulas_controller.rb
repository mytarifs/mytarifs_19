class Price::FormulasController < ApplicationController
  include Price::FormulasHelper
  helper Price::FormulasHelper

  before_action :set_model, only: [:show, :edit, :update, :copy, :destroy]
  before_filter :check_price_formula_params_before_update, only: [:edit, :update]

  def copy
    result = Price::Formula.create!(price_formula.attributes.symbolize_keys.except(:id, :created_at, :updated_at))
    redirect_to price_list_price_formulas_path(hash_with_region_and_privacy({:price_list_id => price_list.id}) ), {notice: "formula was copied with result: #{result}"}
  end
  
  def add
    new_formula = Price::Formula.new(:price_list_id => params['price_list_id'])
    result = new_formula.save
    redirect_to price_list_price_formulas_path(hash_with_region_and_privacy({:price_list_id => price_list.id}) ), {notice: "new_formula was added with result: #{result}"}
  end
  
  def destroy
    message = if price_list.formulas.size > 1
      price_formula.destroy
      "formula was successfully deleted"
    else
      "formual cannot be deleted as it is the only one  remaning"
    end
    redirect_to price_list_price_formulas_path(hash_with_region_and_privacy({:price_list_id => price_list.id}) ), {notice: message}
  end
      
  def update
#    new_price_formula_params = price_formula.attributes.deep_merge(price_formula_params)
    price_formula.assign_attributes(price_formula_params)

    if check_price_formula_params_before_save[0] and price_formula.save
      redirect_to price_list_price_formulas_path(hash_with_region_and_privacy({:price_list_id => price_list.id}) ), {notice: "#{self.controller_name.singularize.capitalize} was successfully updated."}
    else        
      redirect_to price_list_price_formulas_path(hash_with_region_and_privacy({:price_list_id => price_list.id}) ), {alert: check_price_formula_params_before_save[1]}
    end      
  end
  
  def set_model    
    @price_formula = if params[:id] 
      Price::Formula.find(params[:id])
    else  
      Price::Formula.new
    end
  end

  def price_formula_params
    unless params["price_formula"].blank?
      params.require("price_formula").permit!
    else
      {}
    end
  end
        

end
