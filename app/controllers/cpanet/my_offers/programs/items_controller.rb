class Cpanet::MyOffers::Programs::ItemsController < ApplicationController
  include Cpanet::MyOffers::Programs::ItemsHelper
  helper Cpanet::MyOffers::Programs::ItemsHelper

  before_action :set_model, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :set_program_model, only: [:index, :new, :create, :items_load_deeplinks_from_catalog]
  before_action :check_item_params_before_update, only: [:new, :create, :edit, :update]

  def items_load_deeplinks_from_catalog
    result = load_deeplinks_from_catalog    
    redirect_to cpanet_program_items_path(program), result
  end
  
  def create
    item.assign_attributes(item_params)
    item.program_id = program.id
    if item.save
      redirect_to cpanet_programs_item_path(item), notice: "#{self.controller_name.singularize.capitalize} was successfully created."
    else
      render action: 'new', error: item.errors
    end
  end

  def update
    item.assign_attributes(item_params)
    if item.save
      redirect_to cpanet_programs_item_path(item), notice: "#{self.controller_name.singularize.capitalize} was successfully updated."
    else
      render action: 'edit', error: item.errors
    end
  end
  
  def destroy
    if item.status == 'active'
      redirect_to cpanet_program_items_path(item.program_id), notice: "#{item.try(:name)}, {item.try(:id)} is active and cannot be destroyed."
    else
      deleted_item = item.attributes || {}
      item.destroy
      redirect_to cpanet_program_items_path(deleted_item['program_id']), notice: "#{item['name']}, {item['id']} was successfully destroyed."
    end
  end

  def set_model
    @item = if params[:id] 
      Cpanet::MyOffer::Program::Item.find(params[:id])
    else  
      Cpanet::MyOffer::Program::Item.new
    end
  end
   
  def set_program_model
    @program = if params[:program_id] 
      Cpanet::MyOffer::Program.find(params[:program_id])
    else  
      raise(StandardError, "Should be params[:program_id]")
    end
  end

  def item_params
    unless params["cpanet_my_offer_program_item"].blank?
      params.require("cpanet_my_offer_program_item").permit!
    else
      {}
    end
  end

end
