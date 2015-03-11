json.array!(@cages) do |cage|
  json.extract! cage, :id, :name
  json.url cage_url(cage, format: :json)
end
