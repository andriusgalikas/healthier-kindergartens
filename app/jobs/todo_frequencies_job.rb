class TodoFrequenciesJob < ActiveJob::Base
    queue_as :todo

    def perform *args
        Todo.all.each do |todo|

            
        end
    end
end
