Run the following command to translate the data.yaml to cue

```
cue import data.yaml -o temp.cue
```

Run the following command to validate the data using the schema

```
cue vet schema.cue temp.cue
```