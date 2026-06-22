FROM mongo:7

# Files in /docker-entrypoint-initdb.d/ are executed once, in alphabetical
# order, the first time the container starts on an empty data directory. Harbor
# containers are ephemeral, so this runs on every trial.
# .js files run via mongosh (the legacy `mongo` shell is gone in 6+).
COPY seed/ /docker-entrypoint-initdb.d/
