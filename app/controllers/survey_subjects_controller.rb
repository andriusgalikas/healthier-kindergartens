class SurveySubjectsController < ApplicationController
    # before_action -> { authenticate_role!(["parentee", "worker"]) }   
    # before_action :authenticate_subscribed!

    def results
        set_subject
        compile_results
    end

    private

    def set_subject
        @subject ||= SurveySubject.find(params[:id])
    end

    def compile_results
        @results = []
        @subject.surveys.each do |survey|
            attempt = survey.attempts.where(participant_id: current_user.id).first
            unless attempt.nil?
                score = attempt.score
                questions = survey.questions.count
                @results.push([survey.name, (score.to_f/questions.to_f * 100.0)])
            end
        end
    end
end