package example
import core "k8s.io/api/core/v1"

core.#ConfigMap & {
	apiVersion: "v1"
	kind: "ConfigMap"
	metadata: {
		name: "eventbus-source-config"
		labels:
			app: "eventbus-numaflow-poc"
	}
}

