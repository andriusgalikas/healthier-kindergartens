class Manager::SurveySubjectsController < ApplicationController
    layout 'dashboard'
    before_action -> { authenticate_role!(["manager"]) }
    before_action :authenticate_subscribed!

    def index
        set_subjects
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
        @subject ||= SurveySubject.find(params[:id])
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
end