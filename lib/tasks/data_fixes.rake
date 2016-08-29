namespace 'data_fixes' do

  desc 'Set survey_attempts created_at, if null, to the created_at of one of its survey_answers'
  task 'fix_survey_attempts_created_at' => 'environment' do
    SurveyAttempts.all.each do |attempt|
      answer = attempt.survey_answers.first

      attempt.created_at = answer.created_at
      attempt.updated_at = answer.updated_at
      attempt.save
    end
  end

end
