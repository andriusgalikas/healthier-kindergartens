class Manager::SurveysController < ApplicationController
  layout 'dashboard'
  before_action -> { authenticate_role!(["manager"]) }
  before_action :authenticate_subscribed!

  def new
    set_subject
    new_survey
  end

  def edit
    set_subject
    set_survey
  end

  def create
    set_subject
    @survey = @subject.surveys.new(survey_params)
    if @survey.valid? && @survey.save
      redirect_to manager_subject_path(@subject), notice: 'You have created a new survey module'
    else
      render action: :new
    end
  end

  def update
    set_subject
    set_survey
    if @survey.update_attributes(survey_params)
      redirect_to manager_subject_path(@subject), notice: 'You have updated a survey module'
    else
      render action: :edit
    end
  end

  private

  def set_subject
    @subject ||= SurveySubject.find(params[:subject_id])
  end

  def set_survey
    @survey = Survey::Survey.find(params[:id])
  end
  
  def new_survey
    @survey = @subject.surveys.new
  end

  def survey_params
    params.require(:survey_survey).permit(Survey::Survey::AccessibleAttributes)
  end
end
