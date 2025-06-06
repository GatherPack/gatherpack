json.extract! gateway, :id, :name, :type, :provides, :configuration, :created_at, :updated_at
json.url gateway_url(gateway, format: :json)
