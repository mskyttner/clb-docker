vcl 4.0;

backend clbws { 
  .host = "ws";  
  .port = "9000";
  .max_connections = 100;
  .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
  .connect_timeout        = 5s;     # How long to wait for a backend connection?
  .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
}

#backend nubws { 
#  .host = "nubws";  
#  .port = "9002";
#  .max_connections = 100;
#  .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
#  .connect_timeout        = 5s;     # How long to wait for a backend connection?
#  .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
#}

sub vcl_recv {

  # keep original URL in custom header for the ban lurker process later one in vcl_fetch. We modify the request URL here to match the backend apps
  set req.http.x-api-url = req.url;

  if (req.method == "FLUSH") {
          ban("req.http.host == " + req.http.host + " && req.url == /");
          # Throw a synthetic page so the
          # request won't go to the backend.
          return(synth(200, "Flush added"));
  }
  if (req.method == "BAN") {
          ban("req.http.host == " + req.http.host + " && req.url == " + req.url);
          # Throw a synthetic page so the
          # request won't go to the backend.
          return(synth(200, "Ban added"));
  }

  if ( req.url ~ "^/favicon.ico") {
    return(synth(404, "Not found"));
  }

  if (req.url ~ "^/species/(match|lookup)"){
#    set req.backend_hint = nubws;
    set req.backend_hint = clbws;
  } else {
    set req.backend_hint = clbws;
  }
  
  # apparently varnish tries to cache POST requests by converting them to GETs :(
  # https://www.varnish-cache.org/forum/topic/235
  # we therefore make sure we only cache GET requests
  if (req.method == "GET") {
    return (hash);
  } else {
    return(pass);
  }  
}



sub vcl_backend_response {
  # keep original request url in cache for varnishs ban lurker thread:
  # https://www.varnish-software.com/static/book/Cache_invalidation.html#smart-bans
  # x-api-url is set in vcl_recv BAN
  set beresp.http.x-api-url = req.http.x-api-url;

  # 1 hour for all API calls
  set beresp.ttl = 3600s;
  
  return (deliver);
}
