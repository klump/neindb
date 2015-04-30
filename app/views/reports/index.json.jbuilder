json.array!(@reports) do |report|
  json.extract! report, :id, :status, :worker_status, :starttime, :endtime, :data
  json.url report_url(report, format: :json)
end
