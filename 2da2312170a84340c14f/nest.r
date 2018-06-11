library(httr)

# Go to https://developer.nest.com/clients to register a new Nest client

# Nest OAuth 2.0 endpoints
nest <- oauth_endpoint(
  request=NULL,
  authorize="https://home.nest.com/login/oauth2?state=login",
  access="https://api.home.nest.com/oauth2/access_token"
)

# Store your secret in NEST_CONSUMER_SECRET in .Renviron
nest_app <- oauth_app("nest", key="a8bf6e0c-89a0-40ae-869a-943e928316f5")

# Configure your app to require a PIN. The user will have to cut/paste
# the URL in the R Console into a browser then cut/paste the PIN
# back into the R Console
nest_token <- oauth2.0_token(nest, nest_app, use_oob=TRUE, cache=TRUE)

# Nest API usage examples

# Get structures
req <- GET("https://developer-api.nest.com",
           path="structures",
           query=list(auth=nest_token$credentials$access_token))
stop_for_status(req)
structures <-fromJSON(content(req, as="text")

# Get devices
req <- GET("https://developer-api.nest.com",
           path="devices",
           query=list(auth=nest_token$credentials$access_token))
stop_for_status(req)
devices <- fromJSON(content(req, as=text))

# Get 1st thermostat readings
first_thermostat <- names(devices$thermostats)[1]

req <- GET("https://developer-api.nest.com/",
           path=sprintf("devices/thermostats/%s", first_thermostat),
           query=list(auth=nest_token$credentials$access_token))
stop_for_status(req)
thermo <- data.frame(fromJSON(content(req, as="text")),
                     stringsAsFactors=FALSE)

cat(thermo$ambient_temperature_f, "F / ", thermo$humidity, "%", sep="")
