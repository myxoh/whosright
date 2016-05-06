json.array!(@discussions) do |discussion|
  json.extract! discussion, :id, :user_id, :header, :body, :discussion_type_id, :score, :topic_id
  json.url discussion_url(discussion, format: :json)
end
