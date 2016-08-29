class SurveySubjectsController < ApplicationController
    before_action -> { authenticate_role!(["parentee", "worker"]) }
    before_action :authenticate_subscribed!

    def results
        set_subject
        @trend = SurveyTrendsGenerator.new(@subject, [current_user.id])

        if request.xhr?
          render partial: 'progress_charts', locals: {trend: @trend}
        end
    end

    private

    def set_subject
        @subject ||= SurveySubject.find(params[:id])
    end

end
