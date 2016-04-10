class Api::DaycaresController < ApiController

    def index
        set_daycares
        render json: { departments: @daycares.map{|d| daycare_serialisation(d) } }, status: 200
    end

    private

    def set_daycares
        @daycares ||= Daycare.all
    end

    def daycare_serialisation d
        {
            id: d.id,
            name: d.name
        }
    end
end