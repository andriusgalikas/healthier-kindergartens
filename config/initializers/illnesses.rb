ILLNESSES = {
  'rotavirus_infection' => {
    :code     => 'rotavirus_infection',
    :name     => 'Rotavirus Infection',
    :symptoms => []
  },
  'rubella'   => {
    :code     => 'rubella',
    :name     => 'Rubella',
    :symptoms => []
  },
  'salmonellosis' => {
    :code     => 'salmonellosis',
    :name     => 'Salmonellosis',
    :symptoms => []
  },
  'giardiasis' => {
    :code     => 'giardiasis',
    :name     => 'Giardiasis',
    :symptoms => []
  },
  'hepatitis_a' => {
    :code     => 'hepatitis_a',
    :name     => 'Hepatitis A',
    :symptoms => []
  },
  'head_lice' => {
    :code     => 'head_lice',
    :name     => 'Head Lice',
    :symptoms => ['itching']
  },
  'mumps' => {
    :code     => 'mumps',
    :name     => 'Mumps',
    :symptoms => ['fever']
  },
  'spolmark' => {
    :code     => 'spolmark',
    :name     => 'Mark (children mark)/ spolmark',
    :symptoms => ['fever', 'flu']
  },
  'measles' => {
    :code     => 'measles',
    :name     => 'Measles',
    :symptoms => ['fever']
  },
  'meningococcal_disease' => {
    :code     => 'meningococcal_disease',
    :name     => 'Meningococcal Disease',
    :symptoms => ['fever',
                  'diarrhea_with_vomiting',
                  'diarrhea_without_vomiting',
                  'conjunctivitis',
                  'cold',
                  'flu',
                  'cough',
                  'otitis',
                  'impetigo']
  },
  'mrsa' => {
    :code     => 'mrsa',
    :name     => 'MRSA infection and MRSA',
    :symptoms => []
  },
  'norovirus_infection' => {
    :code     => 'norovirus_infection',
    :name     => 'Norovirus Infection',
    :symptoms => []
  },
  'ringworm' => {
    :code     => 'ringworm',
    :name     => 'Ringworm',
    :symptoms => []
  },
  'salmonella_strains' => {
    :code     => 'salmonella_strains',
    :name     => 'Salmonella Strains',
    :symptoms => []
  },
  'shigellosis' => {
    :name     => 'shigellosis',
    :name     => 'Shigellosis',
    :symptoms => []
  },
  'scabies' => {
    :name     => 'scabies',
    :name     => 'Scabies',
    :symptoms => []
  },
  'yersiniosis' => {
    :code     => 'yersiniosis',
    :name     => 'Yersiniosis',
    :symptoms => []
  },
  'chickenpox' => {
    :code     => 'chickenpox',
    :name     => 'Varicella (chickenpox)',
    :symptoms => []
  },
  'typhoid_fever' => {
    :code     => 'typhoid_fever',
    :name     => 'Typhoid Fever',
    :symptoms => []
  },
  'tuberculosis' => {
    :code     => 'tuberculosis',
    :name     => 'Tuberculosis',
    :symptoms => []
  },
  'streptococcus_a' => {
    :code     => 'streptococcus_a',
    :name     => 'Streptococcus, group A (GAS)',
    :symptoms => []
  }
}.with_indifferent_access

SYMPTOMS = {
  'fever'                     => 'Fever',
  'diarrhea_with_vomiting'    => 'Diarrhea With Vomiting',
  'diarrhea_without_vomiting' => 'Diarrhea Without Vomiting',
  'conjunctivitis'            => 'Conjunctivitis',
  'cold'                      => 'Cold',
  'flu'                       => 'Flu',
  'cough'                     => 'Cough',
  'otitis'                    => 'Otitis',
  'impetigo'                  => 'Impetigo',
  'itching'                   => 'Itching'
}.with_indifferent_access
