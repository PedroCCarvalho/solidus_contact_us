module Spree
  module ContactUs
    class ContactMailer < Spree::BaseMailer
      def contact_email(contact)
        @contact = contact
        mail_from = if SolidusContactUs::Config.mailer_from.present?
                      SolidusContactUs::Config.mailer_from
                    else
                      Spree::Store.default.mail_from_address
                    end
        subject = if SolidusContactUs::Config.require_subject
                    @contact.subject
                  else
                    t('spree.subject', email: @contact.email)
                  end

        mail(from: mail_from,
             reply_to: @contact.email,
             subject: subject,
             to: @contact.email)
      end
    end
  end
end
