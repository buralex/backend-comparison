# backend-comparison

Just a boilerplate for starting backends on different languages for comparison.

## Launching comparison on a remote server

1. Clone this repository, go to `backend-comparison` directory and run the script

   Start all backend services (in docker)

   ```bash
   sh start_backends.sh
   ```

2. Now you can access apis:
   | Name | Root url |
   |------------|--------------|
   | Fastify | http://localhost:3028 |
   | Gin | http://localhost:3029 |

   Common routes for all apis:
   | Route | description |
   |------------|--------------|
   | /ping | Returns string "pong" |
   | /users | Returns list of users with posts |

### Commands for benchmarks:

wrk -t4 -c100 -d10s http://localhost:3028/users

wrk -t4 -c100 -d10s http://localhost:3029/users
