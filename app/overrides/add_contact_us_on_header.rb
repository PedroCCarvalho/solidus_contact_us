# frozen_string_literal: true

if SolidusContactUs::Config.link_on_header
  Deface::Override.new(virtual_path: 'spree/shared/_nav_bar',
                       name: 'contact_us_in_header',
                       insert_bottom: 'nav#top-nav-bar ul#nav-bar:first-child',
                       text: "<li class='<%= (request.fullpath.gsub('//','/') == '/contact-us') ? 'active' : ''%>'><%= link_to t('spree.contact_us_title'), '/contact-us'  %></li>")
end
