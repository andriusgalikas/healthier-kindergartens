class Admin::SurveysController < AdminController

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
    # if params[:spreadsheet_file].present? 
    @survey = @subject.surveys.new(survey_params)
    if @survey.valid? && @survey.save
      redirect_to admin_survey_subject_path(@subject), notice: 'You have created a new survey module'
    else
      render action: :new
    end
  end

  def update
    set_subject
    set_survey
    if @survey.update_attributes(survey_params)
      redirect_to admin_survey_subject_path(@subject), notice: 'You have updated a survey module'
    else
      render action: :edit
    end
  end

  def upload
    set_subject
    build_surveys_from_spreadsheet    
    redirect_to admin_survey_subject_path(@subject), notice: 'You have successfully uploaded a new survey module'
  end

  def destroy
    set_subject
    set_survey
    @survey.destroy
    redirect_to admin_survey_subject_path(@subject), notice: 'You have successfully deleted a survey module'
  end

  private

  def set_subject
    @subject ||= SurveySubject.find(params[:survey_subject_id])
  end

  def set_survey
    @survey = Survey::Survey.find(params[:id])
  end
  
  def new_survey
    @survey = @subject.surveys.new
  end

  def survey_params
    params.require(:survey_survey).permit(Survey::Survey::AccessibleAttributes).merge(:spreadsheet_file)
  end

  def build_surveys_from_spreadsheet
    file_data = params[:spreadsheet_file]
    xlsx = Roo::Spreadsheet.open(file_data.tempfile, extension: :xlsx)
    if xlsx.sheets.count > 0
      if xlsx.last_row > 1
        survey = @subject.surveys.build(name: "", description: "Uploaded survey of ", attempts_number: 100000, active: true )
        # survey = Survey::Survey.new(:name => course.title, :description => "details", :attempts_number => 100, :survey_hard_name => course.title, :course_id => course.id)
        if survey.save!
          2.upto(xlsx.last_row) do |line|
            question = survey.questions.new(:text => xlsx.cell(line, 'A')) unless xlsx.cell(line, 'A').nil?
            if question.present? && question.save!
              options = []
              options << question.options.new(:text => xlsx.cell(line, 'B'), :weight => 1, :correct => false) unless xlsx.cell(line, 'B').nil?
              options << question.options.new(:text => xlsx.cell(line, 'C'), :weight => 1, :correct => false) unless xlsx.cell(line, 'C').nil?
              options << question.options.new(:text => xlsx.cell(line, 'D'), :weight => 1, :correct => false) unless xlsx.cell(line, 'D').nil?
              options << question.options.new(:text => xlsx.cell(line, 'E'), :weight => 1, :correct => false) unless xlsx.cell(line, 'E').nil?
              answer = xlsx.cell(line, 'F') unless xlsx.cell(line, 'F').nil?
              p "Question ..........", question
              options.each{|op| op.correct = true if op.text == answer} if options.count > 0 && answer.present?
              options.each{|op| op.save! } if options.count > 0
              p "Options ..........", options
            end
          end
        end
      end
    end
  end
end
