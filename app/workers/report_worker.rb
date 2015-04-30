class ReportWorker
  include Sidekiq::Worker

  def perform(name, count)
  end

  private
  def analyze

  end
end
