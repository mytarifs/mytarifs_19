class Cpanet::MyOffersController < ApplicationController
  include Cpanet::MyOffersHelper
  helper Cpanet::MyOffersHelper

  before_action :set_model, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :check_my_offer_params_before_update, only: [:new, :create, :edit, :update]

  def synchronize
    result = synchronize_my_offers    
    redirect_to cpanet_my_offers_path, result
  end

  def synchronize_offers
    result = synchronize_offers_helper 
    redirect_to cpanet_my_offers_path, result
  end

  def synchronize_catalogs
    result = synchronize_catalogs_helper 
    redirect_to cpanet_my_offers_path, result
  end

  def create
    my_offer.assign_attributes(my_offer_params)
    if my_offer.save
      redirect_to cpanet_my_offer_path(my_offer), notice: "#{self.controller_name.singularize.capitalize} was successfully created."
    else
      render action: 'new', error: my_offer.errors
    end
  end

  def update
    my_offer.assign_attributes(my_offer_params)
    if my_offer.save
      redirect_to cpanet_my_offer_path(my_offer), notice: "#{self.controller_name.singularize.capitalize} was successfully updated."
    else
      render action: 'edit', error: my_offer.errors
    end
  end
  
  def destroy
    if my_offer.status == 'active'
      redirect_to cpanet_my_offers_path, notice: "#{my_offer.try(:name)}, {my_offer.try(:id)} is active and cannot be destroyed."
    else
      my_offer.destroy
      redirect_to cpanet_my_offers_path, notice: "#{my_offer.try(:name)}, {my_offer.try(:id)} was successfully destroyed."
    end
  end

  def set_model
    @my_offer = if params[:id] 
      Cpanet::MyOffer.find(params[:id])
    else  
      Cpanet::MyOffer.new
    end
  end

  def my_offer_params
    unless params["cpanet_my_offer"].blank?
      params.require("cpanet_my_offer").permit!
    else
      {}
    end
  end

end
