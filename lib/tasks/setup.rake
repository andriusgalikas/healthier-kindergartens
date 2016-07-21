namespace 'setup' do

  desc 'Create temporary list of illnesses'
  task 'load_illnesses' => 'environment' do
    YAML::load_file(Rails.root.join('config/initializers/illnesses.yml')).values.each do |illness_desc|
      illness = Illness.find_or_initialize_by(code: illness_desc['code'])
      illness.name = illness_desc['name']
      illness.save
      puts "illness : #{illness.name}"

      if illness_desc['symptoms'].present?
        illness_desc['symptoms'].values.each do |symptom_desc|
          symptom = illness.symptoms.find_or_initialize_by(code: symptom_desc['code'])
          symptom.name = symptom_desc['name']
          symptom.save

          puts "      symptom : #{symptom.name}"
        end
      end
    end
  end
end
