class ApplicationsController < ApplicationController

    require 'sendgrid-ruby'
    include SendGrid

    def create
        send_message
        render json: {message: "Success"}
    end

    def send_message
        from = SendGrid::Email.new(email: ENV['SENDER_ADDRESS'])
        to = SendGrid::Email.new(email: ENV['RECIPIENT_ADDRESS'])
        subject = "Someone submitted an application for #{params[:position]}"
        content = SendGrid::Content.new(type: 'text/plain', value: 'Check out this application')
        mail = SendGrid::Mail.new(from, subject, to, content)

        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        response = sg.client.mail._('send').post(request_body: mail.to_json)
        puts response
    end
end
