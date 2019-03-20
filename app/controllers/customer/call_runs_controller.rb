class Customer::CallRunsController < ApplicationController
  include Crudable
  crudable_actions :all
  include SavableInSession::Tableable
  include Customer::CallRunHelper
  helper Customer::CallRunHelper
#  before_action :init_call_run, only: :calculate_call_stat
  
  before_action :check_call_run_params_before_update, only: [:new, :create, :edit, :update]
  before_action :create_call_run_if_not_exists, only: [:index]
  before_action :check_if_allowed_new_call_run, only: [:new, :create]
  before_action :check_if_allowed_delete_call_run, only: [:destroy]
  
  add_breadcrumb I18n.t(:customer_call_runs_path), nil, :only => :index
  add_breadcrumb I18n.t(:customer_call_runs_path), -> context {context.customer_call_runs_path(context.hash_with_context_region_and_privacy(context)) }, :except => :index
    
  def show
    add_breadcrumb customer_call_run_form.model.try(:name)#, customer_call_run_path(params[:id])
  end
  
  def edit
    add_breadcrumb "Редактирование #{customer_call_run_form.model.try(:name)}"#, edit_customer_call_run_path(params[:id])
  end
  
  def create    
    new_call_run_params = customer_call_run.attributes.deep_merge(call_run_params)
    customer_call_run.assign_attributes(new_call_run_params)

    if customer_call_run.save
      redirect_to customer_call_runs_path(hash_with_region_and_privacy), notice: "#{self.controller_name.singularize.capitalize} was successfully created."
    else
      render action: 'new', error: call_run.errors
    end
  end

  def update    
    new_call_run_params = call_run.attributes.deep_merge(call_run_params)
    customer_call_run.assign_attributes(new_call_run_params)

    if customer_call_run.save
      redirect_to customer_call_runs_path(hash_with_region_and_privacy), notice: "#{self.controller_name.singularize.capitalize} was successfully updated."
    else
      render action: 'edit', error: call_run.errors
    end
  end

  def call_stat
    customer_call_run = Customer::CallRun.where(:id => params[:id]).first
    add_breadcrumb customer_call_run.try(:name)#, customer_call_stat_path(params[:id])
  end

  def calculate_call_stat
    call_run.calculate_call_stat
    redirect_to customer_call_stat_path(hash_with_region_and_privacy({:id => params[:id]})), :notice => "Статистика готова", status: :moved_permanently
  end
  
  def calls_as_json
    calls = Customer::Call.where(:call_run_id => params[:id])
    render json: calls
  end

  def call_run_params
    unless params["customer_call_run_form"].blank?
      params.require("customer_call_run_form").permit!
    else
      {}
    end
  end
  
end
