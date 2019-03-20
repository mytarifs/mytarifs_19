class UsersController < ApplicationController
  include Crudable
  crudable_actions :all
  include SavableInSession::Tableable, Customer::InfoHelper
  
  add_breadcrumb "Профиль пользователя", :user_path, only: [:show, :edit]
  add_breadcrumb " Редактирование", :user_path, only: [:edit]
  
  def users
    options = {:base_name => 'users', :current_id_name => 'user_id', :id_name => 'id', :pagination_per_page => 20}
    create_tableable(User, options)
  end




end
