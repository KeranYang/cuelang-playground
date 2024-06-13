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
