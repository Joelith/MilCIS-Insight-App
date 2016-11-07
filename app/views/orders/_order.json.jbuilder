json.extract! order, :id, :sent, :comments, :status, :requisition_id, :created_at, :updated_at
json.url order_url(order, format: :json)