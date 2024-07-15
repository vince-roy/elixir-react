# Elixir, React and Expo demo
This project contains examples on running Expo, Elixir and React together end-to-end.

## Dev

### Elixir/Phoenix backend
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

### Expo
 * Run `npm --prefix client/expo run web` . 

### React/Vite
 * Run `npm --prefix client/marketing run dev`

### Local Prod
 * Run `CDN_URL="http://localhost:4000/public/expo" mix assets.build`
 * Run `npm run --prefix client/marketing build`
 * Run `MIX_ENV=prod mix phx.server`
 * Go to `http://localhost:4000`
 * React/Vite WIP

 ### Production on Fly.io
 1. Rnu
 Run `fly tokens create deploy -x 999999h` to create a token and set it as the FLY_API_TOKEN secret in your GitHub repository settings
 
 ### Tigris storage
 This is where the client code is stored. Storing with the application itself would result in code split chunks potentially being missing for users after redeploy.

1. Create the storage
 ```sh
 fly storage create
 # https://fly.io/docs/reference/tigris/
 ```

2. Copy the relevant variables in `.env` (see `.env.example` for the variable names)
