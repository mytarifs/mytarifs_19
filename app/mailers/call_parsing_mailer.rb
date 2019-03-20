class CallParsingMailer < ActionMailer::Base
  default from: "calls.tarif@gmail.com"

  def process_message_with_call_details(email)
    puts "Start processing email"
    if email.attachments.size != 1
      puts "Wrong email attachments = #{email.attachments.size}"
      resend_to_admin(email, "mail with call details has #{email.attachments.size} attachments")
    else
      begin
        File.open(email.attachments[0].filename, "w+b", 0644){|f| f.write email.attachments[0].body.decoded}
        file = File.open(email.attachments[0].filename, "r")
      rescue => e
        puts "Unable to save data for #{email.attachments[0].filename} because #{e.message}"
      end

      sender_email = email.from.is_a?(Array) ?  email.from[0] : email.from
      
      message, user = DetailedOptimzationByEmail.new.parce_call_details(sender_email, file)       
      if message[:file_is_good] == false
        puts "Sending email to admin that parsing call detailes failed: #{message.try(:to_s)}, user = #{user.try(:attributes)}"
        resend_to_admin(email, "mail cannot be processed: message = #{message.try(:to_s)}, user = #{user.try(:attributes)}")
        puts "Sent email to admin that parsing call detailes failed"
      else
        puts "Sending email to user on success parsing #{user.try(:attributes)}"
        inform_user_on_success_call_details_parsing(user, email)
        puts "sent email on success"
      end
    end
  end
  
  def inform_user_on_success_call_details_parsing(user, email)
    password = user.encrypted_password.blank? ? ", без пароля" : ""
    body = [
      "Уважаемый пользователь, #{user.email}",
      "",
      "Мы загрузили вашу детализацию, можете продолжить подбор тарифа по ссылке http://www.mytarifs.ru/result/detailed_calculations/new",
      "",
      "Не забудьте залогиниться, ваш логин: #{user.email}#{password}.",
      "",
      "С уважением,",
      "www.mytarifs"
    ].join("\n")
    
    mail(
      to: user.email,
      content_type: "text/plain", 
      subject: "Re: #{email.subject}",
      body: body
    )
  end
  
  def resend_to_admin(email, additional_message = "")
    admin_email = 'mytarifs@yandex.ru'
    redirect_from = 'calls.tarif@gmail.com'
    
    email.attachments.each do | attachment |
      filename = attachment.filename
      file = attachment.body.decoded

      attachments[filename] = file
    end if email.attachments
    
    body = []
    
    body << additional_message if !additional_message.blank?
    
    if email.multipart?       
      body << email.body.preamble
      email.parts.each do |part|
        if part.content_type =~ /text/ or part.content_type =~ /html/
          body << part.body.decoded
        end
      end
      body << email.body.epilogue
    else
      body << email.body.decoded
    end
    
    mail(
      to: admin_email,
      content_type: "multipart/mixed", 
      subject: "Redirect from #{redirect_from} Subject: #{email.subject}",
      body: body.to_s
    )
  end

  
end
