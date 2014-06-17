require "rails_admin_report/engine"

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/index'
require 'rubygems'
require 'pdfkit'
require 'erb'
require 'haml'

module RailsAdminReport
end

module RailsAdmin
  module Config
    module Actions
      class Report < RailsAdmin::Config::Actions::Index
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :link_icon do
          'icon-tasks'
        end

        register_instance_option :route_fragment do
          'report'
        end

        register_instance_option :controller do |args|
          proc do
            @objects ||= list_entries
            unless @model_config.list.scopes.empty?
              if params[:scope].blank?
                unless @model_config.list.scopes.first.nil?
                  @objects = @objects.send(@model_config.list.scopes.first)
                end
              elsif @model_config.list.scopes.collect(&:to_s).include?(params[:scope])
                @objects = @objects.send(params[:scope].to_sym)
              end
            end
            respond_to do |format|
              format.html do
                render @action.template_name, status: (flash[:error].present? ? :not_found : :sucess)
              end

              format.pdf do
                m = t("activerecord.models.#{params[:model_name]}.other")
                filename = "#{m}_#{DateTime.now.strftime("%d-%m-%Y_%Hh%Mm")}.pdf"
                html = render_to_string(action: 'report.pdf.haml')
                kit = PDFKit.new(html)
                kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
                send_data(kit.to_pdf,filename: filename, type: 'application/pdf', disposition: 'inline')
              end
            end
          end
        end
      end
    end
  end
end

module RailsAdmin
  module Config
    module Fields
      class Base
        def footer(params)
          '-'
        end

        def sum(params)
          ActionController::Base.helpers.number_to_currency abstract_model.sum(params, @name)
        end
      end
    end
  end
end

module RailsAdmin
  class AbstractModel
    def sum(params, field)
      all(filters: params[:f], query: params[:query]).map(&field).inject(:+)
    end
  end
end
