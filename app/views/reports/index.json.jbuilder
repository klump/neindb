json.array!(@reports) do |report|
  json.extract! report, :id, :status, :starttime, :endtime, :log, :data
  json.url report_url(report, format: :json)
end
