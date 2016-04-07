class Manager::SurveysController < ApplicationController
  layout 'dashboard'
  before_action -> { authenticate_role!(["manager"]) }

  def index
    set_surveys
  end

  def show
    set_survey
  end

  def new
    new_survey
  end

  def edit
    set_survey
  end

  def create
    @survey = Survey::Survey.new(survey_params)
    if @survey.valid? && @survey.save
      redirect_to manager_surveys_path, notice: 'You have created a new survey!'
    else
      render action: :new
    end
  end

  def update
    set_survey
    if @survey.update_attributes(survey_params)
      redirect_to manager_surveys_path, notice: 'You have updated a survey!'
    else
      render action: :edit
    end
  end

  private

  def set_survey
    @survey = Survey::Survey.find(params[:id])
  end

  def set_surveys
    @surveys = Survey::Survey.all
  end
  
  def new_survey
    @survey = Survey::Survey.new
  end

  def survey_params
    params.require(:survey_survey).permit(Survey::Survey::AccessibleAttributes)
  end
end
