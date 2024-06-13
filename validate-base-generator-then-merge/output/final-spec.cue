apiVersion: "numaflow.numaproj.io/v1alpha1"
kind:       "Pipeline"
metadata: name: "simple-pipeline"
spec: {
	vertices: [{
		name: "in"
		source: generator: {
			rpu:      5
			duration: "1s"
		}
	}, {
		name: "cat"
		udf: builtin: name: "cat"
	}, {
		name: "out"
		sink: log: {}
	}]
	edges: [{
		from: "in"
		to:   "cat"
	}, {
		from: "cat"
		to:   "out"
	}]
}

output: {
  transformed
}