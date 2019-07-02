# frozen_string_literal: true

require 'spec_helper'

describe Spree::ContactUs::Contact do
  let(:contact_params) { { email: 'test@example.com', message: 'message' } }

  describe 'building' do
    it 'methods' do
      allow(contact_params).to receive(:default).and_return('foo')
      expect(described_class.new(contact_params).subject).not_to eq('foo')
    end

    it 'should scrub attributes' do
      expect{ described_class.new(email: 'test@example.com', message: 'foo', destroy: true) }.not_to raise_error
    end

    it 'should not allow bypass of validation' do
      expect(described_class.new(email: 'test@example.com',
        message: 'foo', 'validation_context' => 'update').validation_context).
        not_to eq('update')
    end
  end

  describe 'Validations' do
    context 'with name and subject settings' do
      after do
        SolidusContactUs::Config.require_name = false
        SolidusContactUs::Config.require_subject = false
      end

      before do
        SolidusContactUs::Config.require_name = true
        SolidusContactUs::Config.require_subject = true
      end
    end
  end

  describe 'Methods' do
    let(:contact) do
      Spree::ContactUs::Contact.new(email: 'Valid@Email.com', message: 'Test')
    end
    let(:mail) { Mail.new(from: 'Valid@Email.com', to: 'test@test.com') }

    describe '#save' do
      it 'should return false if records invalid' do
        allow(contact).to receive(:message).and_return('')
        expect(contact.save).to eq(false)
      end

      it 'should send email and return true if records valid' do
        allow(mail).to receive(:deliver_now).and_return(true)
        allow(Spree::ContactUs::ContactMailer).to receive(:contact_email).
          with(contact).and_return(mail)
        expect(contact.save).to eq(true)
      end
    end
  end
end
