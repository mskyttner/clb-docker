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

  # this bans matching objects via regex from being served if older than the ban
  if (req.method == "BAN") {
    ban("obj.http.x-api-url ~ " + req.http.x-ban-url);
    error 200 "Banned";
  }

  # remove whatever host we got, as varnish adds the backend hostname if none exists in the request
  remove req.http.host;

  # remove cookies in weird case they exist
  remove req.http.Cookie;

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }

  if (req.url ~ "^/species/(match|lookup)"){
#    set req.backend = nubws;
    set req.backend = clbws;
  } else {
    set req.backend = clbws;
  }
  
  # apparently varnish tries to cache POST requests by converting them to GETs :(
  # https://www.varnish-cache.org/forum/topic/235
  # we therefore make sure we only cache GET requests
  if (req.method == "GET") {
    return (lookup);
  } else {
    return(pass);
  }  
}



sub vcl_fetch {
  # keep original request url in cache for varnishs ban lurker thread:
  # https://www.varnish-software.com/static/book/Cache_invalidation.html#smart-bans
  # x-api-url is set in vcl_recv BAN
  set beresp.http.x-api-url = req.http.x-api-url;

  #
  # CACHE CONTROL
  #
  # remove no cache headers.
  # Cache-Control: mag-age takes precendence over Last-Modified or ETags:
  # https://www.varnish-cache.org/trac/wiki/VCLExampleLongerCaching
  # http://stackoverflow.com/questions/6451137/etag-attribute-present-but-no-cache-control-present-in-http-header
  # http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html
  remove beresp.http.Cache-Control;

  # 1 hour for all API calls
  set beresp.ttl = 3600s;
  
  return (deliver);
}

sub vcl_error {
  if (obj.status == 301) {
    set obj.http.Location = obj.response;
    set obj.status = 301;
    return (deliver);
  }
}
