class ServiceInformationMailer < ActionMailer::Base
  default from: "team.tarif@gmail.com"

  #ServiceInformationMailer.service_introduction.deliver_now
  def service_introduction
    email = "ayakushev@rambler.ru"
    mail(to: email, subject: 'Подбор выгодных тарифов и опций мобильной связи')
  end


end
