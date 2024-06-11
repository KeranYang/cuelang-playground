// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/numaproj/numaflow/pkg/apis/numaflow/v1alpha1

package v1alpha1

import corev1 "k8s.io/api/core/v1"

// ContainerTemplate defines customized spec for a container
#ContainerTemplate: {
	// +optional
	resources?: corev1.#ResourceRequirements @go(Resources) @protobuf(1,bytes,opt)

	// +optional
	imagePullPolicy?: corev1.#PullPolicy @go(ImagePullPolicy) @protobuf(2,bytes,opt,casttype=PullPolicy)

	// +optional
	securityContext?: null | corev1.#SecurityContext @go(SecurityContext,*corev1.SecurityContext) @protobuf(3,bytes,opt)

	// +optional
	env?: [...corev1.#EnvVar] @go(Env,[]corev1.EnvVar) @protobuf(4,bytes,rep)

	// +optional
	envFrom?: [...corev1.#EnvFromSource] @go(EnvFrom,[]corev1.EnvFromSource) @protobuf(5,bytes,rep)
}
