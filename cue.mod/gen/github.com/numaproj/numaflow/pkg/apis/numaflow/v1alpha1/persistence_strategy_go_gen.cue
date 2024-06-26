// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/numaproj/numaflow/pkg/apis/numaflow/v1alpha1

package v1alpha1

import (
	corev1 "k8s.io/api/core/v1"
	apiresource "k8s.io/apimachinery/pkg/api/resource"
)

// PersistenceStrategy defines the strategy of persistence
#PersistenceStrategy: {
	// Name of the StorageClass required by the claim.
	// More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#class-1
	// +optional
	storageClassName?: null | string @go(StorageClassName,*string) @protobuf(1,bytes,opt)

	// Available access modes such as ReadWriteOnce, ReadWriteMany
	// https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes
	// +optional
	accessMode?: null | corev1.#PersistentVolumeAccessMode @go(AccessMode,*corev1.PersistentVolumeAccessMode) @protobuf(2,bytes,opt,casttype=k8s.io/api/core/v1.PersistentVolumeAccessMode)

	// Volume size, e.g. 50Gi
	volumeSize?: null | apiresource.#Quantity @go(VolumeSize,*apiresource.Quantity) @protobuf(3,bytes,opt)
}
