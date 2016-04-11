class SurveySubjectsController < ApplicationController
    # before_action :authenticate_subscribed!

    def results
        set_subject
        load_attempt_user
        if @subject.surveys.count > 0
            if @group == true
                compile_group_results
            else
                compile_user_results
            end
        else
            render :text => "error"
        end
    end

    def get_results
        set_subject
        load_attempt_user
        if @subject.surveys.count > 0
            if @group == true
                compile_group_results
            else
                compile_user_results
            end
            render :partial => "bar_graph", :locals => {:@course_results => @course_results, :@group => @group}
        else
            render :text => "error"
        end
    end

    private

    def set_subject
        @subject ||= SurveySubject.find(params[:id])
    end

    def group?
        (params[:group].present? && params[:group] == true) ? true : false
    end

    def compile_user_results
        @course_results = []
        @subject.surveys.each do |survey|
            attempt = survey.attempts.where(participant_id: current_user.id).first
            unless attempt.nil?
                score = attempt.score
                questions = survey.questions.count
                @course_results << score.to_f/questions.to_f * 100.0
            end
            @course_results << 0 if attempt.nil?
        end
    end

    def compile_group_results
        @workers = current_daycare.workers
        @parents = current_daycare.parents
        @course_results = [0.0, 1.0]
        attempts = []
        @reviewed_ids = []
        pending = 0
        reviewed = 0
        @subject.surveys.each do |survey|
            survey.attempts.map{|s| attempts << s if @workers.pluck(:id).include?(s.participant_id)}
        end
        if attempts.count > 0
            attempts.each do |attempt|
                if attempt.is_reviewed == true
                    reviewed+=1
                    @reviewed_ids << attempt.participant_id
                else
                    pending+=1
                end
            end
        end
        @course_results = [reviewed, pending]
    end

    def load_attempt_user
        if params[:user_id].present?
            @attempt_user = User.find(params[:user_id])
        else
            @attempt_user = current_user
        end
        @group = to_boolean(params[:group]) if params[:group].present?
    end

    def to_boolean str
        str == 'true'
    end
end