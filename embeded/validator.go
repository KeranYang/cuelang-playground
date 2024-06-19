package embeded

import (
	"embed"
	"fmt"
	"io/fs"
	"log"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
	"gopkg.in/yaml.v2"
)

// Embed all CUE schema files and the cue.mod directory
//
//go:embed cue.mod/module.cue
//go:embed cue.mod/gen/*
//go:embed schemas/*/*/*.cue
var content embed.FS

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

// Helper to read embedded files
func readFile(fs embed.FS, path string) []byte {
	data, err := fs.ReadFile(path)
	if err != nil {
		log.Fatalf("failed reading file from path %s: %v", path, err)
	}
	return data
}

func loadInstance(ctx *cue.Context, schemaPath string) *cue.Value {
	overlay := make(map[string]load.Source)
	prefix := "schemas"

	// Iterate over embedded schema files and module files
	err := fs.WalkDir(content, prefix, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.IsDir() {
			fileData := readFile(content, path)
			// fmt.Printf("Loading schema file: %s\n", string(fileData))
			// fmt.Printf("Loading schema file: %s\n", path)
			absPath := "/" + path
			overlay[absPath] = load.FromBytes(fileData)
		}
		return nil
	})
	if err != nil {
		log.Fatalf("failed to walk through schemas directory: %v", err)
	}

	// Overlay must include the module configuration
	// moduleCueContent := readFile(content, "cue.mod/module.cue")
	// fmt.Printf("Module cue content: %s\n", string(moduleCueContent))
	// overlay["/cue.mod/module.cue"] = load.FromBytes(moduleCueContent)

	fmt.Printf("Overlay")
	for k, v := range overlay {
		fmt.Printf("Key: %s, Value: %s\n", k, v)
	}

	instConfig := &load.Config{
		Dir:        "/",
		ModuleRoot: "/cue.mod",
		Overlay:    overlay,
	}

	buildInstances := load.Instances([]string{"/" + schemaPath}, instConfig)
	if len(buildInstances) == 0 || buildInstances[0].Err != nil {
		log.Printf("Error loading instances: %v\n", buildInstances[0].Err)
		return nil
	}

	inst := ctx.BuildInstance(buildInstances[0])
	if inst.Err() != nil {
		log.Printf("Error building instance from schema: %v\n", inst.Err())
		return nil
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
