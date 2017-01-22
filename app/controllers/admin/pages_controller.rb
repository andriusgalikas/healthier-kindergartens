require 'yaml2csv/hash_extensions'
Yaml2csv.extend_hash
class Admin::PagesController < AdminController

  def lang_dashboard
  end

  def clients
    if params[:country]
      @clients = Daycare.includes(:discount_code).where(country: params[:country].downcase, :created_at => 14.days.ago..Time.now)
    else
      @clients = Daycare.includes(:discount_code).where(:created_at => 14.days.ago..Time.now)
    end
  end

  def upload
    unless params[:web_url].blank?
      web_url = LocaleUrl.find_or_create_by(url: params[:web_url])
      web_url.language = params[:language_short_name].downcase
      web_url.save      
    end 

    build_translate_from_yml

    build_template_from_spreadsheet

    build_invite_template_from_spreadsheet

    build_verify_template_from_spreadsheet    

    build_todo_from_spreadsheet

    build_illness_from_spreadsheet

    redirect_to admin_lang_main_path
  end

  def list_message
    get_all_template_subjects
  end

  def list_invite
    get_all_invitation_subjects
  end

  def list_verify
    get_all_verify_subjects
  end

  private

  def get_all_template_subjects
    @subjects = MessageSubject.template_subjects
    @subjects = @subjects.main_title_like(params[:title]) unless params[:title].nil?
    @subjects = @subjects.main_by_language(params[:language]) unless params[:language].nil? || params[:language].blank?

  end

  def get_all_invitation_subjects
    @subjects = MessageSubject.invite_subjects
    @subjects = @subjects.main_title_like(params[:title]) unless params[:title].nil?
    @subjects = @subjects.main_by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
  end

  def get_all_verify_subjects
    @subjects = MessageSubject.verify_subjects
    @subjects = @subjects.main_title_like(params[:title]) unless params[:title].nil?
    @subjects = @subjects.main_by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
  end

  def build_translate_from_yml
    if params[:yml_file]
      content = File.read(params[:yml_file].tempfile)
      doc = YAML.load(content)

      Translation.where(:locale => params[:language_short_name].downcase).destroy_all

      doc.to_enum(:walk).each do |path, key, value|
        strvalue = value.is_a?(String) ? value : value.inspect
        trans_item = Translation.new
        trans_item.locale = params[:language_short_name].downcase
        path_str = path.join(".")
        path_dot_index = path_str.index('.') + 1
        trans_item.key = "#{path_str[path_dot_index..-1]}.#{key}"
        trans_item.value = value
        trans_item.save
      end
      I18n.backend.reload!
    end
  rescue => e
    flash[:alert] = "Upload yml is failed."
  end

  def build_template_from_spreadsheet
    file_data = params[:message_template]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          MessageSubject.where(:language => params[:language_short_name].downcase)
                        .where.not("message_subjects.title LIKE :search", :search => "%#{ENV['SURVEY_TEMPLATE_SUBJECT']}%").destroy_all
          2.upto(xlsx.last_row) do |line|
            @subject = MessageSubject.find_or_create_by(title: xlsx.cell(line, 'A'), :language => params[:language_short_name].downcase) if xlsx.cell(line, 'A')
            @sub_subject = @subject.sub_subjects.create(title: xlsx.cell(line, 'B'), :language => params[:language_short_name].downcase) if xlsx.cell(line, 'B')
            template = @sub_subject.message_templates.create(target_role: xlsx.cell(line, 'C').downcase, language: params[:language_short_name].downcase, content: xlsx.cell(line, 'D'))
          end        
        end
      end
    end
  rescue => e
    flash[:alert] = "Upload message template is failed."
  end

  def build_invite_template_from_spreadsheet
    file_data = params[:invite_template]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          MessageSubject.where(:language => params[:language_short_name].downcase).where("message_subjects.title LIKE :search", :search => "%#{ENV['SURVEY_TEMPLATE_SUBJECT']}%").destroy_all
          2.upto(xlsx.last_row) do |line|
            @subject = MessageSubject.find_or_create_by(title: ENV['SURVEY_TEMPLATE_SUBJECT'], :language => params[:language_short_name].downcase) 
            template_key = 'SURVEY_TEMPLATE_SUBJECT_' + xlsx.cell(line, 'A').upcase if xlsx.cell(line, 'A')
            @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => params[:language_short_name].downcase)            
            @sub_subject.message_templates.where(target_role: MessageTemplate.target_roles[xlsx.cell(line, 'A').downcase], language: params[:language_short_name].downcase).destroy_all
            template = @sub_subject.message_templates.create(target_role: xlsx.cell(line, 'A').downcase, language: params[:language_short_name].downcase, content: xlsx.cell(line, 'B'))
          end        
        end
      end
    end
  rescue => e
    flash[:alert] = "Upload invite template is failed."
  end

  def build_verify_template_from_spreadsheet
    file_data = params[:verify_template]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          MessageSubject.where(:language => params[:language_short_name].downcase).where("message_subjects.title LIKE :search", :search => "%#{ENV['EMAIL_VERIFICATION_SUBJECT']}%").destroy_all
          2.upto(xlsx.last_row) do |line|
            @subject = MessageSubject.find_or_create_by(title: ENV['EMAIL_VERIFICATION_SUBJECT'], :language => params[:language_short_name].downcase) 
            template_key = 'EMAIL_VERIFICATION_SUBJECT_' + xlsx.cell(line, 'A').upcase if xlsx.cell(line, 'A')
            @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => params[:language_short_name].downcase)            
            @sub_subject.message_templates.where(target_role: 0, language: params[:language_short_name].downcase).destroy_all
            template = @sub_subject.message_templates.create(target_role: 0, language: params[:language_short_name].downcase, content: xlsx.cell(line, 'B'))
          end        
        end
      end
    end
  rescue => e
    flash[:alert] = "Upload email verification template is failed."
  end

  def build_todo_from_spreadsheet
    file_data = params[:todo_template]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          SubTask.transaction do
            TodoTask.transaction do
              Todo.transaction do
                Todo.where(:language => params[:language_short_name].downcase).destroy_all
                2.upto(xlsx.last_row) do |line|
                  unless (xlsx.cell(line, 'A').nil? || xlsx.cell(line, 'A').strip.blank?)
                    frequency = 0

                    unless xlsx.cell(line, 'C').nil?
                      case xlsx.cell(line, 'C').downcase
                      when 'day'
                        frequency = 0
                      when 'week'
                        frequency = 1
                      when 'month'
                        frequency = 2
                      when 'year'
                        frequency = 3
                      else
                        frequency = 0
                      end                  
                    end

                    completion_date_type = 0
                    case xlsx.cell(line, 'E').downcase
                    when 'day'
                      completion_date_type = 0
                    when 'week'
                      completion_date_type = 1
                    when 'month'
                      completion_date_type = 2
                    when 'year'
                      completion_date_type = 3
                    when 'hour'
                      completion_date_type = 4
                    else
                      completion_date_type = 0
                    end

                    @todo = Todo.new( :title => xlsx.cell(line, 'A'), 
                                      :iteration_type => (xlsx.cell(line, 'B').downcase == 'single') ? 0 : 1, 
                                      :frequency => (xlsx.cell(line, 'B').downcase == 'single') ? nil : frequency,
                                      :completion_date_value => (xlsx.cell(line, 'D').nil?) ? 0 : xlsx.cell(line, 'D').to_i,
                                      :completion_date_type => completion_date_type,
                                      :user_id => current_user.id,
                                      :language => params[:language_short_name].downcase
                                    )
                    #@todo.build_icon
                    @todo.save(validate: true)

                    @departments = Department.all
                    @departments.each do |item|
                      @todo_dept = DepartmentTodo.new(todo_id: @todo.id, department_id: item.id)
                      @todo_dept.save
                    end
                  end

                  unless xlsx.cell(line, 'F').nil? || xlsx.cell(line, 'F').strip.blank?
                    @todo_task = @todo.tasks.new(
                                      :title => xlsx.cell(line, 'F'),
                                      :description => xlsx.cell(line, 'G') ,
                                      :task_type => 0,
                                      :language => params[:language_short_name].downcase
                      )
                    @todo_task.save(validate: true)
                  end           
                  sub_task = @todo_task.sub_tasks.new(
                                      :title => xlsx.cell(line, 'H'),
                                      :sub_task_type => 0,
                                      :language => params[:language_short_name].downcase
                      )
                  sub_task.save(validate: true)
                end        
              end 
            end 
          end
        end
      end
    end
  rescue => e
    flash[:alert] = "Upload todo is failed."
  end

  def build_illness_from_spreadsheet
    file_data = params[:illness_template]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          index = Time.now.to_i     
          Illness.where(:language => params[:language_short_name].downcase).destroy_all     
          2.upto(xlsx.last_row) do |line|
            index += 1
            unless xlsx.cell(line, 'A').nil?
              @illness = Illness.new(:code => "IL-#{index}", :name => xlsx.cell(line, 'A'), :language => params[:language_short_name].downcase)
              @illness.save(validate: true)
            end
            symptom = @illness.symptoms.new(:code => "SY-#{index}", :name => xlsx.cell(line, 'B')) unless xlsx.cell(line, 'B').nil?
            symptom.save(validate: true)
          end        
        end
      end
    end
  rescue => e
    flash[:alert] = "Upload illness is failed."
  end

end
