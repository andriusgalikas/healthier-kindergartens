class Manager::SurveySubjectsController < ApplicationController
    layout 'dashboard', except: :results
    before_action -> { authenticate_role!(["manager"]) }
    before_action :authenticate_subscribed!

    def index
        set_subjects
    end

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

    def show
        set_subject
    end

    def new
        new_subject
        new_icon_attachment
    end

    def edit
        set_subject
    end

    def create
        @subject = SurveySubject.new(subject_params)
        if @subject.save
            redirect_to manager_subject_path(@subject), notice: 'You have created a new subject'
        else
            new_icon_attachment
            render action: :new
        end
    end

    def update
        set_subject
        if @subject.update_attributes(subject_params)
            redirect_to manager_subject_path_path(@subject), notice: 'You have updated a subject'
        else
            render action: :edit
        end
    end

    private

    def new_icon_attachment
      @subject.build_icon
    end

    def set_subject
        @subject ||= SurveySubject.find(params[:subject_id])
    end

    def set_subjects
        @subjects = SurveySubject.all
    end
  
    def new_subject
        @subject = SurveySubject.new
    end

    def subject_params
        params.require(:survey_subject).permit(:daycare_id, :title, :description, icon_attributes: [:id, :attachable_type, :attachable_id, :file]).merge(daycare_id: current_user.daycare.id)
    end

    def compile_group_results subject
        set_workers
        set_parents
        @results = []
        subject.surveys.each do |survey|
            total_survey_score = survey.attempts.map(&:score).sum
            total_questions = (survey.questions.count*survey.attempts.size)
            @results.push([survey.name, (total_survey_score.to_f/total_questions.to_f * 100.0)])
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