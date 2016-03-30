json.array!(@plans) do |plan|
  json.extract! plan, :id, :name, :price, :allocation
  json.url plan_url(plan, format: :json)
end
