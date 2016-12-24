require 'yaml2csv/hash_extensions'
Yaml2csv.extend_hash
class Admin::PagesController < AdminController
  def localization

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

    redirect_to admin_localization_path
  end

  private

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
  end

  def build_template_from_spreadsheet
    file_data = params[:message_template]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          2.upto(xlsx.last_row) do |line|
            @subject = MessageSubject.find_or_create_by(title: xlsx.cell(line, 'A')) if xlsx.cell(line, 'A')
            @sub_subject = @subject.sub_subjects.create(title: xlsx.cell(line, 'B')) if xlsx.cell(line, 'B')
            template = @sub_subject.message_templates.create(target_role: xlsx.cell(line, 'C').downcase, language: params[:language_short_name].downcase, content: xlsx.cell(line, 'D'))
          end        
        end
      end
    end
  end

  def build_invite_template_from_spreadsheet
    file_data = params[:invite_template]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          2.upto(xlsx.last_row) do |line|
            @subject = MessageSubject.find_or_create_by(title: ENV['SURVEY_TEMPLATE_SUBJECT']) 
            template_key = 'SURVEY_TEMPLATE_SUBJECT_' + xlsx.cell(line, 'A').upcase if xlsx.cell(line, 'A')
            @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key])            
            @sub_subject.message_templates.where(target_role: MessageTemplate.target_roles[xlsx.cell(line, 'A').downcase], language: params[:language_short_name].downcase).destroy_all
            template = @sub_subject.message_templates.create(target_role: xlsx.cell(line, 'A').downcase, language: params[:language_short_name].downcase, content: xlsx.cell(line, 'B'))
          end        
        end
      end
    end
  end

end
