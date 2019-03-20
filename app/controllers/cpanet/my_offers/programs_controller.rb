class Cpanet::MyOffers::ProgramsController < ApplicationController
  include Cpanet::MyOffers::ProgramsHelper
  helper Cpanet::MyOffers::ProgramsHelper

  before_action :set_model, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :set_my_offer, only: [:index, :new, :create]
  before_action :check_program_params_before_update, only: [:new, :create, :edit, :update]

  def create
    program.assign_attributes(program_params)
    program.my_offer_id = my_offer.id
    if program.save
      redirect_to cpanet_program_path(program), notice: "#{self.controller_name.singularize.capitalize} was successfully created."
    else
      render action: 'new', error: program.errors
    end
  end

  def update
    program.assign_attributes(program_params)
    if program.save
      redirect_to cpanet_program_path(program), notice: "#{self.controller_name.singularize.capitalize} was successfully updated."
    else
      render action: 'edit', error: program.errors
    end
  end
  
  def destroy
    if program.status == 'active'
      redirect_to cpanet_my_offer_programs_path(program.my_offer_id), notice: "#{program.try(:name)}, {program.try(:id)} is active and cannot be destroyed."
    else
      program.destroy
      redirect_to cpanet_my_offer_programs_path(program.my_offer_id), notice: "#{program.try(:name)}, {program.try(:id)} was successfully destroyed."
    end
  end

  def set_model
    @program = if params[:id] 
      Cpanet::MyOffer::Program.find(params[:id])
    else  
      Cpanet::MyOffer::Program.new
    end
  end

  def set_my_offer
    @my_offer = if params[:my_offer_id] 
      Cpanet::MyOffer.find(params[:my_offer_id])
    else  
      raise(StandardError, "Should be params[:my_offer_id]")
    end
  end

  def program_params
    unless params["cpanet_my_offer_program"].blank?
      params.require("cpanet_my_offer_program").permit!
    else
      {}
    end
  end

end
