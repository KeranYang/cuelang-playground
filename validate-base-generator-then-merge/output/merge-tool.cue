package main

base: {
		metadata: name: "simple-pipeline"
		spec: {
			vertices: [{
				name: "in"
				source: {}
			}, {
				name: "cat"
				udf: builtin: name: "cat" // A built-in UDF which simply cats the message
			}, {
				name: "out"
				sink: {
					// A simple log printing sink
					log: {}}
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

vertex: {
	name: "in"
	source: {
		// A self data generating source
		generator: {
			rpu:      5
			duration: "1s"
		}
	}
}

transformed: {
	  apiVersion: "numaflow.numaproj.io/v1alpha1"
		kind:       "Pipeline"
    metadata: base.metadata
    spec: vertices: [
        for v in base.spec.vertices {
            if v.name == vertex.name {
                vertex
            } // else {
            	// TODO - how to do else?
            	// v
            //}
        }
    ]
    spec: edges: base.spec.edges
}