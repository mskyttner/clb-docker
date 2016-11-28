vcl 4.0;

backend clbws { 
  .host = "ws";  
  .port = "9000";
  .max_connections = 100;
  .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
  .connect_timeout        = 5s;     # How long to wait for a backend connection?
  .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
}

backend nubws { 
  .host = "ws";  
  .port = "9000";
  .max_connections = 100;
  .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
  .connect_timeout        = 5s;     # How long to wait for a backend connection?
  .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
}

sub vcl_recv {
  if (req.method == "FLUSH") {
    ban("obj.http.url ~ .*");
    return (synth(204, "Flushing everything"));     
  }
  if (req.method == "BAN") {
    ban("obj.http.url ~ " + req.http.X-Ban-URL);
    return (synth(204, "Banned " + req.http.X-Ban-URL));
   }

  if ( req.url ~ "^/favicon.ico") {
    return(synth(404, "Not found"));
  }

  if (req.url ~ "^/species/(match|lookup)"){
    set req.backend_hint = nubws;
  } else {
    set req.backend_hint = clbws;
  }
  
  # Only cache GETtish requests
  if (req.method == "OPTIONS" || req.method == "HEAD" || req.method == "GET") {
    return (hash);
  } else {
    return(pass);
  }  
}

sub vcl_synth {
  if (resp.status == 701) {
    set resp.http.Location = resp.reason;
    set resp.reason = "Moved Permanently";
    set resp.status = 301;
    return (deliver);
  }
}

sub vcl_backend_response {
  # Record for banning URLs
  set beresp.http.url = bereq.url;
}

sub vcl_deliver {
  unset resp.http.url;
}
