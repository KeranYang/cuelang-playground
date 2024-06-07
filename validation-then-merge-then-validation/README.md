### TL;DR

To use cuelang to validate eventbus config map, all we need is the configuration data
in yaml format.

We can validate it against configuration data schema
and then programmatically merge it with the eventbus static template to generate the final config map spec.

### Import k8s dependencies

https://cuelang.org/docs/howto/generate-cue-from-go-dependency/

### Validate configuration data and generate the configuration cue

Run the following command to translate the data.yaml to cue

```
cue import data.yaml -o temp-config-data.cue
```

Run the following command to validate the data using the schema

```
cue vet eventbus-config-schema.cue temp-config-data.cue
```

### Merge the configuration with the eventbus config map template to form the final config map spec

Currently, I am manually doing so.

```
cue export eventbus-config-map-schema.cue --out yaml > final-spec.yaml
```

Manually add to final-spec the configuration data.

### Validate against the config map k8s template

```
cue import final-spec.yaml -o final-spec.cue
```

Run the following command to validate the data using the schema

```
cue vet eventbus-config-map-schema.cue final-spec.cue -c
```