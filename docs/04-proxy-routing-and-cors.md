cat > docs/04-proxy-routing-and-cors.md << 'EOF'
# Proxy Routing & CORS

## Nginx Configuration

File: `proxy/nginx.conf`

### Routes
| Path | Proxied To | Purpose |
|------|-----------|---------|
| / | http://app:3000 | All app routes (HTML + API) |
| /assets/ | http://app:3000/assets/ | Static files |
| /health | http://app:3000/health | Health check endpoint |

### CORS
CORS is handled in `server.js` using the `cors` npm package:
```js
const cors = require('cors');
app.use(cors({ origin: '*' }));
```
This allows all origins — suitable for development/demo.
For production, restrict to your domain:
```js
app.use(cors({ origin: 'http://<EC2_PUBLIC_IP>' }));
```

### Security Headers
```nginx
add_header X-Frame-Options "SAMEORIGIN";
add_header X-Content-Type-Options "nosniff";
```

### Structured JSON Logging
```nginx
log_format json_combined escape=json
  '{"time":"$time_local",'
  '"ip":"$remote_addr",'
  '"request":"$request",'
  '"status":"$status",'
  '"bytes":"$body_bytes_sent",'
  '"response_time":"$request_time"}';
```
EOF