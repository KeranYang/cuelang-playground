package main

userInputBase: {
		metadata: name: "simple-pipeline"
		spec: {
			vertices: [{
				name: "in"
			}, {
				name: "cat"
			}, {
				name: "out"
			}]
			edges: [{
				from: "in"
				to:   "cat"
			}, {
				from: "cat"
				to:   "out"
			}]
		}
}

userInputVertices: [
	{
			name: "in"
			source: {
				generator: {
					rpu:      5
					duration: "1s"
				}
			}
	},
	{
			name: "cat"
			udf: builtin: name: "cat"
	},
	{
			name: "out"
			sink: log: {}
	},
]

transformed: {
	  apiVersion: "numaflow.numaproj.io/v1alpha1"
		kind:       "Pipeline"
    metadata: userInputBase.metadata
    spec: vertices: [
        for v in userInputBase.spec.vertices {
        	for userInputVertex in userInputVertices {
        		if v.name == userInputVertex.name {
                userInputVertex
            }
        	}
        }
    ]
    spec: edges: userInputBase.spec.edges
}