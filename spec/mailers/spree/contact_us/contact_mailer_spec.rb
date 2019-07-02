# frozen_string_literal: true

require 'spec_helper'

describe Spree::ContactUs::ContactMailer do
  let!(:store) { create(:store, default: true) }
  let(:contact) do
    Spree::ContactUs::Contact.new(email: 'test@email.com',
                                  message: 'Thanks!')
  end

  before do
    contact.subject = "Contact Us message from #{contact.email}"
  end

  describe '#contact_email' do
    it 'should render successfully' do
      expect{ described_class.contact_email(contact) }.not_to raise_error
    end

    it 'should use the mailer_from setting when it is set' do
      expect(described_class.contact_email(contact).from).to eq([store.mail_from_address])
    end

    describe 'rendered without error' do
      let(:mailer) { Spree::ContactUs::ContactMailer.contact_email(contact) }

      it 'should have the initializers to address' do
        expect(mailer.to).to eq([contact.email])
      end

      it 'should use the users email from SolidusContactUs::Config.mailer_from is set' do
        SolidusContactUs::Config.mailer_from = 'user@test.com'
        expect(mailer.from).to eq([SolidusContactUs::Config.mailer_from])
        SolidusContactUs::Config.mailer_from = nil
      end

      it 'should use the users email in the from store when SolidusContactUs::Config.mailer_from is not set' do
        expect(mailer.from).to eq([store.mail_from_address])
      end

      it 'should use the users email in the reply_to field' do
        expect(mailer.reply_to).to eq([contact.email])
      end

      it 'should have users email in the subject line' do
        expect(mailer.subject).to eq("Contact Us message from #{contact.email}")
      end

      it 'should have the message in the body' do
        expect(mailer.body).to match('<p>Thanks!</p>')
      end

      it 'should deliver successfully' do
        expect { Spree::ContactUs::ContactMailer.contact_email(contact).deliver }.
          not_to raise_error
      end

      describe 'and delivered' do
        it 'should be added to the delivery queue' do
          expect { Spree::ContactUs::ContactMailer.contact_email(contact).deliver }.
            to change(ActionMailer::Base.deliveries, :size).by(1)
        end
      end
    end
  end
end
