json.array!(@positions) do |position|
  json.extract! position, :id, :discussion_id, :email, :name, :body, :score
  json.url position_url(position, format: :json)
end
