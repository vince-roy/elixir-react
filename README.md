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
 * Run `MIX_ENV=prod mix phx.server`
 * Go to `http://localhost:4000`
 * React/Vite WIP

 ### Production on Fly.io