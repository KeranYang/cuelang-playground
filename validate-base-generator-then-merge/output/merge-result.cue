base: {
	metadata: name: "simple-pipeline"
	spec: {
		vertices: [{
			name: "in"
			source: {}
		}, {
			name: "cat"
			udf: builtin: name: "cat"
		}, {
			name: "out"
			sink: {
				// A simple log printing sink
				log: {}
			}
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
	metadata: name: "simple-pipeline"
	spec: {
		vertices: [{
			name: "in"
			source: {
				// A self data generating source
				generator: {
					rpu:      5
					duration: "1s"
				}
			}
		}, {}, {}]
		edges: [{
			from: "in"
			to:   "cat"
		}, {
			from: "cat"
			to:   "out"
		}]
	}
}