class Manager::SurveySubjectsController < ApplicationController
    before_action -> { authenticate_role!(["manager"]) }
    before_action :authenticate_subscribed!

    def results
        set_subject
        compile_group_results(@subject)
    end

    def user_result
        set_subject
        compile_results
        render json: { partial: render_to_string(partial: 'survey_subjects/bar_graph', locals: { results: @results}) }, stauts: 200
    end

    def group_result
        set_subject
        compile_group_results(@subject)
        render json: { partial: render_to_string(partial: 'survey_subjects/bar_graph', locals: { results: @results}) }, stauts: 200
    end

    private

    def set_subject
        @subject ||= SurveySubject.find(params[:subject_id])
    end

    def compile_group_results subject
        set_workers
        set_parents
        @results = []
        subject.surveys.each do |survey|
            total_survey_score = survey.attempts.map(&:score).sum
            total_questions = (survey.questions.count*survey.attempts.size)
            @results.push([survey.name, (total_survey_score.to_f/total_questions.to_f * 100.0)]) unless total_survey_score.zero? && total_questions.zero?
        end
    end

    def compile_results
        @results = []
        @subject.surveys.each do |survey|
            attempt = survey.attempts.where(participant_id: params[:user_id]).first
            unless attempt.nil?
                score = attempt.score
                questions = survey.questions.count
                @results.push([survey.name, (score.to_f/questions.to_f * 100.0)])
            end
        end
    end

    def set_workers
        @workers = current_daycare.workers
    end

    def set_parents
        @parents = current_daycare.parents
    end
end