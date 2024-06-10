#!/bin/bash
env $(cat .env | grep -v "#" | xargs) mix phx.server