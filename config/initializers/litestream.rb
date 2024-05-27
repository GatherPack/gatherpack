# Use this hook to configure the litestream-ruby gem.
# All configuration options will be available as environment variables, e.g.
# config.replica_bucket becomes LITESTREAM_REPLICA_BUCKET
# This allows you to configure Litestream using Rails encrypted credentials,
# or some other mechanism where the values are only avaialble at runtime.

litestream_credentials = begin; Rails.application.credentials.litestream rescue nil; end

if litestream_credentials
  Litestream.configure do |config|
    config.replica_bucket = litestream_credentials.replica_bucket
    config.replica_key_id = litestream_credentials.replica_key_id
    config.replica_access_key = litestream_credentials.replica_access_key
  end
end
