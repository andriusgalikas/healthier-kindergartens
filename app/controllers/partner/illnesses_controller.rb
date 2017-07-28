class Partner::IllnessesController < ApplicationController
  layout 'dashboard_v2'
  before_action -> {authenticate_role!(["partner", "worker"])}
  before_action :strategic_partnership!

  def set_filters
    set_daycares
  end

  def trends
    @trend = IllnessTrendsGenerator.new(current_user, params)
  end

  private

    def set_daycares
        @daycares ||= Daycare.all
    end

end
