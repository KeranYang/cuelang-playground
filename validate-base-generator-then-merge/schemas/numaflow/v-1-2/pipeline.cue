package pipeline
import numafv1 "github.com/numaproj/numaflow/pkg/apis/numaflow/v1alpha1"

numafv1.#Pipeline & {
	apiVersion: "numaflow.numaproj.io/v1alpha1"
	kind: "Pipeline"
	metadata: name: string | *"default"
}
