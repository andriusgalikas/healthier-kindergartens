class Users::WorkersController < ApplicationController
    layout 'dashboard'

    def select_daycare
        set_query
        set_daycares
    end

    def select_department
        set_daycare
        set_departments
    end

    private

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_daycares
        @daycares ||= params[:query].present? ? Daycare.search(@query, params[:page], 100, 300) : Daycare.all
    end

    def set_daycare
        @daycare ||= Daycare.find(params[:daycare_id])
    end

    def set_departments
        @departments ||= @daycare.departments
    end
end