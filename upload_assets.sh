#!/bin/bash
env $(cat .env | grep -v "#" | xargs) elixir priv/asset_upload.exs