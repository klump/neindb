class ReportWorker
  include Sidekiq::Worker

  class AlreadyInProgress < StandardError; end
  class AlreadyDone < StandardError; end
end
