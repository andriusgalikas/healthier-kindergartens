class Manager::DaycaresController < ApplicationController
    layout 'registration'
    before_action -> { authenticate_role!(["manager"]) }

    def send_invites    	
        DaycareInviteEmailJob.perform_later(params[:emails].join(','))
        redirect_to dashboard_url, notice: "Successfully sent your invites"
    end
end