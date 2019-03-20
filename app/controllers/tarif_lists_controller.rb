class TarifListsController < ApplicationController
  include TarifListsHelper
  helper TarifListsHelper
  helper_method :tarif_list

  before_action :set_model, only: [:destroy]
  before_action :reload_page_from_operator_tarif_list, only: [:scrap]
  before_action :general_task_runner, only: [:scrap]
  before_action :process_tarif_list_collection_filtr, only: [:scrap]
  before_action :process_service_list_parsing, only: [:scrap]
  before_action :process_scraped_info_from_tarif_list_for_parsing_filtr, only: [:scrap]
  before_action :update_search_services_tag, only: [:scrap]

  def destroy
    @tarif_list.destroy
    redirect_to scrap_tarif_lists_path, notice: "#{@tarif_list.try(:name)}, {@tarif_list.try(:id)} was successfully destroyed."
  end
      
  def set_model
    @tarif_list = if params[:id] 
      TarifList.find(params[:id])
    else  
      TarifList.new
    end

  end

  def tarif_list_params
    unless params["tarif_list"].blank?
      params.require("tarif_list").permit!
    else
      {}
    end
  end
        

end
