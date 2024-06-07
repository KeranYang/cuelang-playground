{
	// Define the root structure
	topicName: string
	topicNameHeaderKey: string
	appSecretKey: string
	idpsConfig: {
		idpsProperties: {
			policy_id: string
			endpoint: string
			force_generic_policies: bool
		}
	}
	eventBusConfig: {
		clusterEnvironment: string
		tmsClientConfig: {
			assetId: string
			intuitAppId: string
			environment: string
			gatewayAuthContextType: string
			offlineJobId: string
			identityServiceMeshEnabled: bool
			debugLoggingEnabled: bool
		}
		idpsClientConfig: {
			idpsProperties: {
				policy_id: string
				endpoint: string
				force_generic_policies: bool
			}
		}
		consumerConfig: {
			kafkaProperties: {
				"group.id": string
				"auto.offset.reset": string
				"max.poll.interval.ms": number
				"max.poll.records": number
			}
		}
	}
}
