class ApplicationMailer < ActionMailer::Base
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@mailby.goodbyt.es"
  layout 'mailer'
end
