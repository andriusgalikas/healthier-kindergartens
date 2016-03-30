class Admin::DaycaresController < AdminController

    def index
        set_daycares
    end

    private

    def set_daycares
        @daycares ||= Daycare.all
    end
end