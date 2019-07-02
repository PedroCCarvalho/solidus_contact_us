module Spree
  module ContactUs
    class ContactsController < Spree::StoreController
      helper 'spree/products'

      def create
        @contact = Spree::ContactUs::Contact.new(params[:contact_us_contact])

        if @contact.save
          if SolidusContactUs::Config.contact_tracking_message.present?
            flash[:contact_tracking] = SolidusContactUs::Config.contact_tracking_message
          end
          redirect_to spree.root_path, notice: t('spree.contact_us.notices.success')
        else
          render :new
        end
      end

      def new
        @contact = Spree::ContactUs::Contact.new
        @taxonomies = Spree::Taxonomy.includes(root: :children)
      end
    end
  end
end
