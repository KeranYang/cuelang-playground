package embeded

import (
	"fmt"
	"os"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
	"gopkg.in/yaml.v2"
)

func ValidatePipelineSpec(input []byte) bool {
	ctx := cuecontext.New()
	schemaInstance := loadInstance(ctx, "schemas/numaflow/v-1-2/pipeline.cue")
	if err := schemaInstance.Err(); err != nil {
		fmt.Printf("Error loading schema: %v\n", err)
		return false
	}
	specInstance := generateCueValueOfYamlEncoding(ctx, input)
	if unified := specInstance.Unify(schemaInstance.LookupPath(cue.ParsePath("#Data"))); unified.Err() != nil {
		fmt.Printf("Error unifying spec with schema: %v\n", unified.Err())
		return false
	}
	return true
}

func loadInstance(cxt *cue.Context, filename string) *cue.Value {
	buildInstances := load.Instances([]string{filename}, &load.Config{})
	if buildInstances[0].Err != nil {
		fmt.Printf("Error loading %s: %v\n", filename, buildInstances[0].Err)
		os.Exit(1)
	}
	inst := cxt.BuildInstance(buildInstances[0])
	if inst.Err() != nil {
		fmt.Printf("Error building instance from %s: %v\n", filename, inst.Err())
		os.Exit(1)
	}
	return &inst
}

// generateCueValueOfYamlEncoding generates a CUE value from a YAML byte array.
func generateCueValueOfYamlEncoding(cueCtx *cue.Context, input []byte) *cue.Value {
	var i interface{}
	if err := yaml.Unmarshal(input, &i); err != nil {
		return nil
	}
	converted := convertMapKeysToString(i)
	specInstance := cueCtx.Encode(converted)
	return &specInstance
}

func convertMapKeysToString(i interface{}) interface{} {
	switch x := i.(type) {
	case map[interface{}]interface{}:
		m := make(map[string]interface{})
		for k, v := range x {
			m[fmt.Sprint(k)] = convertMapKeysToString(v)
		}
		return m
	case []interface{}:
		for idx, val := range x {
			x[idx] = convertMapKeysToString(val)
		}
	}
	return i
}
