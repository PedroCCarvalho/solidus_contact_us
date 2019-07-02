# frozen_string_literal: true

module SolidusContactUs
  class Configuration < Spree::Preferences::Configuration
    preference :mailer_from, :string, default: ''
    preference :require_name, :boolean, default: false
    preference :require_subject, :boolean, default: false
    preference :contact_tracking_message, :string, default: nil
    preference :link_on_header, :boolean, default: true
    preference :link_on_footer, :boolean, default: true
  end
end
