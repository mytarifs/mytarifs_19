# Preview all emails at http://localhost:3000/rails/mailers/service_information_mailer
class ServiceInformationMailerPreview < ActionMailer::Preview
  def service_introduction
    ServiceInformationMailer.service_introduction
  end
end
