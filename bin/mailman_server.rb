#!/usr/bin/env ruby

#require 'rubygems'
#require 'bundler/setup'
require 'mailman'

require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

Mailman.config.logger = Logger.new("log/mailman.log")  # uncomment this if you can want to create a log file
Mailman.config.poll_interval = 60  # change this number as per your needs. Default is 60 seconds

Mailman.config.rails_root = '.'

Mailman.config.pop3 = {
  server: 'pop.gmail.com', port: 995, ssl: true,
  username:  ENV['CALLS_TEAM_GMAIL_USERNAME'],
  password:  ENV['CALLS_TEAM_GMAIL_PASSWORD']
}

Mailman::Application.run do
  subject(/етализаци/) do
    begin
      puts params.to_s
      CallParsingMailer.process_message_with_call_details(message).deliver_now 
    rescue Exception => e
      Mailman.logger.error "Exception occurred while receiving message:n#{message}"
      Mailman.logger.error [e, *e.backtrace].join("\n")
    end
  end
  
  default do
    begin
#      puts params.to_s
      CallParsingMailer.resend_to_admin(message).deliver_now
    rescue Exception => e
      Mailman.logger.error "Exception occurred while receiving message:n#{message}"
      Mailman.logger.error [e, *e.backtrace].join("\n")
    end
  end
end
