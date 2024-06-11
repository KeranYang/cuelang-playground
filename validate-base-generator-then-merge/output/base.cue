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

