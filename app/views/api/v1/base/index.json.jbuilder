json.collection do
  json.version 1
  json.href api_root_url(format: :json)

  json.links [
    { rel: "reports", href: api_reports_url(format: :json) },
    { rel: "assets", href: api_assets_url(format: :json) },
    { rel: "components", href: api_components_url(format: :json) }
  ]
end
