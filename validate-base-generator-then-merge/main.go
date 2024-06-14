package main

import (
	"fmt"
	"os"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/format"
	"cuelang.org/go/cue/load"
)

func main() {
	cxt := cuecontext.New()
	// Load base configuration
	baseInst := loadInstance(cxt, "output/base.cue")

	// Mapping from vertex names to vertex instance values.
	verticesToUpdate := make(map[string]cue.Value)

	// Vertex files
	vertexFiles := []string{"output/in.cue", "output/cat.cue", "output/out.cue"}
	for _, file := range vertexFiles {
		vertexInst := loadInstance(cxt, file)
		name := vertexInst.Lookup("name")
		if name.Exists() {
			vertexName, _ := name.String()
			verticesToUpdate[vertexName] = vertexInst.Value()
		} else {
			fmt.Printf("Vertex in file %s does not have a 'name' field\n", file)
		}
	}

	// Process base vertices and replace/update with matched vertices from other files
	baseVertices := baseInst.Lookup("base", "spec", "vertices")
	if baseVertices.Exists() {
		var newVertices []cue.Value
		baseVerticesList, err := baseVertices.List()
		if err != nil {
			fmt.Println("Error retrieving list of vertices from base:", err)
			os.Exit(1)
		}

		for baseVerticesList.Next() {
			baseVertex := baseVerticesList.Value()
			nameVal, _ := baseVertex.Lookup("name").String()
			if replacementVertex, ok := verticesToUpdate[nameVal]; ok {
				newVertices = append(newVertices, replacementVertex)
			} else {
				newVertices = append(newVertices, baseVertex)
			}
		}

		// Compose the new vertices into a list to be unified with the base instance
		newVertexList := cxt.NewList(newVertices...)
		verticesPath := cue.ParsePath("base.spec.vertices")
		updatedBase := baseInst.FillPath(verticesPath, newVertexList)
		// To print updated content, we need to use format package to prettify the output
		syn := updatedBase.Syntax(cue.ResolveReferences(true), cue.Final())
		bytes, _ := format.Node(syn)
		fmt.Println(string(bytes))
	}
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
