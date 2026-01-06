SRC="./workflows.json"
OUTDIR="./"

rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

# Split + sanitize
jq -c '.[]' "$SRC" | while IFS= read -r wf; do
  # versionId non-null (si null/absent)
  VID="$(uuidgen)"

  # nom de fichier safe
  NAME="$(echo "$wf" | jq -r '.name // "workflow"' | tr -cs '[:alnum:]._-' '_' | cut -c1-80)"
  FILE="$OUTDIR/${NAME}_${VID}.json"

  echo "$wf" | jq --arg vid "$VID" '
    .active = false
    | del(.id)                                # IMPORTANT: évite "Could not find workflow"
    | .versionId = (.versionId // $vid)       # IMPORTANT: évite NOT NULL
    | del(.createdAt, .updatedAt)             # optionnel
  ' > "$FILE"
done

echo "✅ Workflows clean générés dans: $OUTDIR"
ls -1 "$OUTDIR" | head

