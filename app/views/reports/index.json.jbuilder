json.array!(@reports) do |report|
  json.extract! report, :id, :status, :parser_status, :starttime, :endtime, :data
  json.url report_url(report, format: :json)
end
