class Report < ActiveRecord::Base
  STATUS = %w(running success failure)
  WORKER_STATUS = %w(parsing success failure)

  has_many :revisions, as: :trigger
  belongs_to :asset
  belongs_to :user

  validates :status, presence: true, inclusion: STATUS
  validates :parser_status, inclusion: WORKER_STATUS, allow_nil: true
  validates :starttime, presence: true

  def append collector, identifier, text
    return unless text.is_a? String

    @data = {} if @data.nil?
    @data[collector] = {} if @data[collector].nil?
    @data[collector][identifier] = "" if @data[collector][identifier].nil?

    # append the text to the message
    @data[collector][identifier] += "#{text}\n"
  end
end
