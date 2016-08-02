class SurveyTrendsGenerator

=begin
 params :
    subject : SurveySubject
    population: user ids of the participants to generate data out of
=end
  def initialize(subject, user_population)
    @subject = subject
    @user_population = user_population
  end

  def survey_result_over_time
    trend_data = []

    trend_data << header_columns
    date_labels.each do |date|
      trend_data << generate_trend_row(date)
    end

    trend_data
  end

  private

  def survey_attempts_population
    @survey_attempts_involved ||= SurveyAttempts.where(survey_id: subject.survey_ids, participant_id: @user_population)
  end

  def header_columns
    @header_columns ||= ['Date'] + survey_attempt_dates.keys
  end

=begin
  output :
  {
    "Exclusion of Sick Children" => {
      2016-06-01 00:00:00 UTC => 1,
      2016-07-01 00:00:00 UTC => 3
    },
    "Infection Preventive Outbreak Control" => {
      2016-06-01 00:00:00 UTC => 3,
      2016-07-01 00:00:00 UTC => 7
    }
  }
=end
  def survey_attempt_dates
    @attempt_dates ||= (
      @subject.surveys.inject({}) do |list, survey|
        attempts = attempts_per_survey(survey)
        if attempts.present?
          attempts.each_pair{|date, average| attempts[date] = average.to_i}

          list[survey.name] = attempts
        end
        list
      end
    )
  end

  def attempts_per_survey(survey_id)
    SurveyAttempts.where(survey_id: survey_id, participant_id: @user_population).group("DATE_TRUNC('month', created_at)").average('score')
  end

  def date_labels
    survey_attempt_dates.values.map(&:keys).flatten.uniq.sort
  end

  def generate_trend_row(date)
    row = Array.new(header_columns.size, 0)
    row[0] = date.strftime('%b %Y')

    header_columns.each_with_index do |survey, index|
      next if index == 0

      row[index] = survey_attempt_dates[survey][date] || 0
    end

    row
  end
end
