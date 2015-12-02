set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server '51.254.143.140', user: 'deploy', roles: %w{web app}
