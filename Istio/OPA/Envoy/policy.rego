package envoy.authz

import input.attributes.request.http as http_request

default allow = {
  "allowed": false,
  "headers": {"x-ext-auth-allow": "no"},
  "body": "Unauthorized Request",
  "http_status": 301
}

allow = response {
  input.attributes.request.http.method == "GET"
  response := {
      "allowed": true,
      "headers": {"x-ext-auth-allow": "yes"},
      "body": "Authorized Request",
      "http_status": 201
  }
}



