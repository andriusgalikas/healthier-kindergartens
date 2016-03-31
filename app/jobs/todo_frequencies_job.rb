class TodoFrequenciesJob < ActiveJob::Base
    queue_as :todo

    def perform *args
    end
end
