class Manager::DaycaresController < ApplicationController

    def invite
    end

    def send_invites
        DaycareInviteEmailJob.perform_later(params[:emails])
        redirect_to dashboard_url, notice: "Successfully sent your invites"
    end
end