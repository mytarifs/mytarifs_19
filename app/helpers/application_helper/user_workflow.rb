module ApplicationHelper::UserWorkflow
  
  def redirect_user_to_registration_or_main_tarif_optimization
    session[:work_flow][:tarif_optimization] ||= {} 
    session[:work_flow][:tarif_optimization][:status] = "ready_to_calculate"
    session[:work_flow][:tarif_optimization][:call_run_id] = session[:filtr]["call_run_choice_filtr"]['customer_call_run_id'].to_i
    if user_type == :guest      
      redirect_to new_user_registration_path, notice: "Детализация звонков загружена. Можете приступить к подбору тарифов.\
      Мы предлагаем вам оставить адрес электронной почты для того, чтобы мы могли сообщить вам об окончании расчетов, а также\
      чтобы вы не потеряли доступ к вашим расчетам." and return
    else
      accounting_period = Customer::Call.where(:call_run_id => session[:work_flow][:tarif_optimization][:call_run_id]).first.try(:description).try(:[], 'accounting_period')
      run = Result::Run.where(:call_run_id => session[:work_flow][:tarif_optimization][:call_run_id]).first_or_create(
        :name => "Подбор тарифа", :description => "", :user_id => current_or_guest_user_id, :run => 1, :optimization_type_id => 0,
        :call_run_id => session[:work_flow][:tarif_optimization][:call_run_id], :accounting_period => accounting_period)
      session[:current_id]['result_run_id'] = run.try(:id)
      redirect_to result_runs_path(hash_with_region_and_privacy), notice: "Детализация звонков загружена. Можете приступить к подбору тарифов" and return
    end    
  end
end
