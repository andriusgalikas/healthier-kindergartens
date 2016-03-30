json.array!(@todos) do |todo|
  json.extract! todo, :id, :title, :due_date, :iteration_type, :frequency, :daycare_id, :user_id
  json.url todo_url(todo, format: :json)
end
