class ApplicationsController < ApplicationController

    require 'sendgrid-ruby'
    include SendGrid

    def create
        send_message
        render json: {message: "Success"}
    end

    def send_message
        mail = SendGrid::Mail.new
        mail.from = SendGrid::Email.new(email: ENV['SENDER_ADDRESS'])
        personalization = SendGrid::Personalization.new
        personalization.add_to(SendGrid::Email.new(email: 'andrew@aimsparking.com'))
        personalization.add_dynamic_template_data(application_params.merge({subject: "#{application_params[:position]} | New Application"}))
        mail.add_personalization(personalization)
        mail.template_id = ENV['SENDGRID_TEMPLATE_ID']

        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        response = sg.client.mail._("send").post(request_body: mail.to_json)
    end

    private
    def application_params
        params.require(:application).permit!
    end
end
