#!/bin/sh
CONTAINER_CONFIG_JSON=$1

USER_ID=$(jq -r '.User' $CONTAINER_CONFIG_JSON)
ENTRYPOINT=$(jq -r '.Entrypoint | join(" ")' $CONTAINER_CONFIG_JSON)
WORKDIR=$(jq -r '.WorkingDir' $CONTAINER_CONFIG_JSON)
ENV_VARS=$(jq -r '.Env' $CONTAINER_CONFIG_JSON | tr -d '[]",')

# loop over lists of entrypoints and concat into a single string
for entrypoint in $ENTRYPOINTS; do
    ENTRYPOINT="$ENTRYPOINT $entrypoint"
done


echo "#!/bin/sh"
echo cd $WORKDIR
for EV in $ENV_VARS; do
echo "export $EV"
done
echo su -c "$ENTRYPOINT" $USER_ID

# above su command won'r work for containers that don't have su installed.