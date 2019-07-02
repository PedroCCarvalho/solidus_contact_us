# frozen_string_literal: true

if SolidusContactUs::Config.link_on_footer
  Deface::Override.new(virtual_path: 'spree/shared/_footer',
                       name: 'contact_us_in_footer',
                       insert_bottom: '#footer-right',
                       text: "<p class='<%= (request.fullpath.gsub('//','/') == '/contact-us') ? 'current' : 'not'%>'><%= link_to t('spree.contact_us_title'), '/contact-us'  %></p>")
end
