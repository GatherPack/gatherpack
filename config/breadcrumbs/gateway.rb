crumb :gateways do
  link "Gateways", gateways_path
end

crumb :gateway do |gateway|
  link gateway.identifier_name, gateway
  parent :gateways
end

crumb :"gateway/stripe_gateway" do |gateway|
  link gateway.identifier_name, gateway_path(gateway)
  parent :gateways
end