server {
    server_name  ${domain};
    
    root /code/website-gradimo-zajedno/GradimoZajedno.Web/wwwroot;
    index index.html;

    proxy_buffer_size   128k;
    proxy_buffers   4 256k;
    proxy_busy_buffers_size   256k;
    large_client_header_buffers 4 16k;
    
    location / {
        proxy_pass         http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;

        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        
        client_max_body_size 20M; # limit file upload size; default is 1MB, "0" is unlimited
    }
}