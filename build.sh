mix deps.get --only prod
MIX_ENV=prod mix compile

mix phx.digest

rm -rf "_build"
MIX_ENV=prod mix release