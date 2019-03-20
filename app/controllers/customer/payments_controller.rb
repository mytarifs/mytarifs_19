class Customer::PaymentsController < ApplicationController
  before_action :build_payment_instruction, only: [:new, :create]
#  attr_reader :payment_confirmation
  after_action :track_new, only: :new
  after_action :track_create, only: :create
  after_action :track_process_payment, only: :process_payment

  def new
    add_breadcrumb "Выбор параметров платежа"#, new_customer_payments_path
  end
  
  def create    
    if @payment_instruction.valid?        
      redirect_to @payment_instruction.url_to_yandex(current_or_guest_user)
    else
      render 'new'
    end
  end
  
  def wait_for_payment_being_processed
    if customer_has_free_trials?('optimization_steps')
      redirect_to result_detailed_calculations_new_path(hash_with_region_and_privacy)
    end
  end
  
  def process_payment
    payment_confirmation = Customer::PaymentConfirmation.new(params)
    payment_confirmation.process_payment    
    respond_to do |format|
      format.all {render nothing: true, status: 200}
    end
  end
  
  private
  
    def build_payment_instruction      
      if params[:customer_payment]
        @payment_instruction = Customer::Payment.new(params[:customer_payment].permit!)
      else
        @payment_instruction = Customer::Payment.new()
      end
      
    end

  def track_new
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#      'params' => params,
#    })
  end

  def track_create
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#      'params' => params,
#      'valid' => @payment_instruction.valid?,
#      'yandex_params' => @payment_instruction.to_yandex_params,
#    })
  end

  def track_process_payment
 #   ahoy.track("#{controller_name}/#{action_name}", {
 #     'flash' => flash,      
 #     'params' => params,
 #   })
  end

    
end

