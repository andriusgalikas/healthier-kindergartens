class SurveySubjectsController < ApplicationController
    layout 'dashboard_v2'
    before_action -> { authenticate_role!(["parentee", "worker"]) }
    before_action :authenticate_subscribed!

    def results
        set_subject
        if request.xhr?
          render partial: 'progress_charts'
        end
    end

    def result
        @subject ||= SurveySubject.find(params[:id])
        @trend = SurveyTrendsGenerator.new(@subject, [current_user.id])
        if request.xhr?
          render partial: 'progress_charts', locals: {trend: @trend}
        end
    end

    private

    def set_subject
        @subject ||= SurveySubject.where(language: I18n.locale.upcase).first
    end
end
