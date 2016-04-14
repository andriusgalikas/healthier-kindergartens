class Admin::SurveySubjectsController < AdminController

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
            # build_surveys_from_spreadsheet if subject_params[:spreadsheet_file].present?
            redirect_to admin_subject_path(@subject), notice: 'You have created a new subject'
        else
            new_icon_attachment
            render action: :new
        end
    end

    def update
        set_subject
        if @subject.update_attributes(subject_params)
            redirect_to admin_subject_path(@subject), notice: 'You have updated a subject'
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
        params.require(:survey_subject).permit(:daycare_id, :spreadsheet_file, :title, :description, icon_attributes: [:id, :attachable_type, :attachable_id, :file]).merge(daycare_id: current_user.daycare.id)
    end

    def build_surveys_from_spreadsheet
    	file_data = course_params[:file]
		xlsx = Roo::Spreadsheet.open(file_data.tempfile, extension: :xlsx)
		if xlsx.sheets.count > 0
			if xlsx.last_row > 1
				survey = Survey::Survey.new(:name => course.title, :description => "details", :attempts_number => 100, :survey_hard_name => course.title, :course_id => course.id)
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