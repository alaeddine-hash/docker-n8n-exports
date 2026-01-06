WORKDIR=./   # <-- your folder with *.json

for f in "$WORKDIR"/*.json; do
  tmp="$(mktemp)"

  # generate one uuid per file (good enough and minimal)
  UUID="$(uuidgen)"

  jq --arg uuid "$UUID" '
    def fix:
      .active = false
      | .versionId = (
          if (.versionId == null or .versionId == "") then $uuid else .versionId end
        );

    if type=="array" then
      map(fix)
    else
      fix
    end
  ' "$f" > "$tmp" && mv "$tmp" "$f"
done

