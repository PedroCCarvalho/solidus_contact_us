# frozen_string_literal: true

require 'spec_helper'

describe 'Contact Us page', type: :feature, js: true do
  let!(:store) { create(:store, default: true) }

  after do
    ActionMailer::Base.deliveries = []
    SolidusContactUs::Config.require_name = false
    SolidusContactUs::Config.require_subject = false
    SolidusContactUs::Config.mailer_from = ''
  end

  before do
    ActionMailer::Base.deliveries = []
    SolidusContactUs::Config.require_name = false
    SolidusContactUs::Config.require_subject = false
    SolidusContactUs::Config.mailer_from = ''
  end

  it 'displays default contact form properly' do
    visit spree.contact_us_path

    within 'form#new_contact_us_contact' do
      expect(page).to have_selector 'input#contact_us_contact_email'
      expect(page).to have_selector 'textarea#contact_us_contact_message'
      expect(page).to_not have_selector 'input#contact_us_contact_name'
      expect(page).to_not have_selector 'input#contact_us_contact_subject'
      expect(page).to have_selector 'input#contact_us_contact_submit'
    end
  end

  context 'Submitting the form' do
    let(:mail) { ActionMailer::Base.deliveries.last }

    before do
      visit spree.contact_us_path
    end

    context 'when valid' do
      before do
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Message', with: 'howdy'
        click_button 'Submit'
      end

      it 'I should be redirected to the homepage' do
        expect(current_path).to eql('/')
      end

      it 'The email should have been sent with the correct attributes' do
        expect(mail.to).to eq(['test@example.com'])
        expect(mail.from).to eq([store.mail_from_address])
        expect(mail.body).to match('howdy')
        expect(ActionMailer::Base.deliveries.size).to eql(1)
      end
    end

    context 'when valid with configuration' do
      let(:mail) { ActionMailer::Base.deliveries.last }

      before do
        visit spree.contact_us_path
        SolidusContactUs::Config.mailer_from = 'spree@example.com'
      end

      context 'when valid' do
        before do
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Message', with: 'howdy'
          click_button 'Submit'
        end

        it 'The email should have been sent with the config mailer_from attribute' do
          expect(mail.to).to eq(['test@example.com'])
          expect(mail.from).to eq(['spree@example.com'])
          expect(mail.body).to match('howdy')
          expect(ActionMailer::Base.deliveries.size).to eql(1)
        end
      end
    end

    context 'when invalid' do
      context 'Email and message are invalid' do
        before do
          fill_in 'Email', with: 'a'
          fill_in 'Message', with: ''
          click_button 'Submit'
        end

        it 'I should see two error messages' do
          expect(page).to have_content('Email is invalid')
          expect(page).to have_content("Message can't be blank")
        end

        it 'An email should not have been sent' do
          expect(ActionMailer::Base.deliveries.size).to eql(0)
        end
      end
    end
  end

  context 'with name and subject configuration' do
    after do
      SolidusContactUs::Config.require_name = false
      SolidusContactUs::Config.require_subject = false
    end

    before do
      SolidusContactUs::Config.require_name = true
      SolidusContactUs::Config.require_subject = true
      visit spree.contact_us_path
    end

    it 'displays an input for name and subject' do
      expect(page).to have_selector('input#contact_us_contact_name')
      expect(page).to have_selector('input#contact_us_contact_subject')
    end

    context 'Submitting the form' do
      let(:mail) { ActionMailer::Base.deliveries.last }

      context 'when valid' do
        before do
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Message', with: 'howdy'
          fill_in 'contact_us_contact[name]', with: 'Jeff'
          fill_in 'contact_us_contact[subject]', with: 'Testing contact form.'
          click_button 'Submit'
        end

        it 'I should be redirected to the homepage' do
          expect(current_path).to eql('/')
        end

        it 'The email should have been sent with the correct attributes' do
          expect(mail.body).to match 'howdy'
          expect(mail.body).to match 'Jeff'
          expect(mail.to).to eql(['test@example.com'])
          expect(mail.from).to eql([store.mail_from_address])
          expect(mail.subject).to match 'Testing contact form.'
          expect(ActionMailer::Base.deliveries.size).to eql(1)
        end

      end

      context 'Submitting the form with configuration' do
        let(:mail) { ActionMailer::Base.deliveries.last }

        before do
          SolidusContactUs::Config.mailer_from = 'spree@example.com'
        end

        context 'when valid' do
          before do
            fill_in 'Email', with: 'test@example.com'
            fill_in 'Message', with: 'howdy'
            fill_in 'contact_us_contact[name]', with: 'Jeff'
            fill_in 'contact_us_contact[subject]', with: 'Testing contact form.'
            click_button 'Submit'
          end

          it 'The email should have been sent with the config mailer_from attribute' do
            expect(mail.body).to match 'howdy'
            expect(mail.body).to match 'Jeff'
            expect(mail.to).to eql(['test@example.com'])
            expect(mail.from).to eql(['spree@example.com'])
            expect(mail.subject).to match 'Testing contact form.'
            expect(ActionMailer::Base.deliveries.size).to eql(1)
          end
        end
      end

      context 'when name and subject are blank' do
        before do
          click_button 'Submit'
        end

        it 'I should see error messages' do
          expect(page).to have_content('There were problems with the following fields:')
        end

        it 'An email should not have been sent' do
          expect(ActionMailer::Base.deliveries.size).to eql(0)
        end
      end
    end
  end
end
