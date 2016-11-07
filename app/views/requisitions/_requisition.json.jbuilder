json.extract! requisition, :id, :id, :title, :description, :amount, :status, :location, :created_at, :updated_at
json.url requisition_url(requisition, format: :json)