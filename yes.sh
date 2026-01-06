cd ~/n8n-docker

WORKDIR=./n8n-workflow  # <-- ajuste si besoin

for f in "$WORKDIR"/*.json; do
  tmp="$(mktemp)"
  jq '
    if type=="array" then
      map(.active=false | del(.versionId))
    else
      (.active=false | del(.versionId))
    end
  ' "$f" > "$tmp" && mv "$tmp" "$f"
done

