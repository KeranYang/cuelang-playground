package main

{
    metadata: {
        name: name
    }
    spec: {
        vertices: [...#Vertex]
        edges: [...#Edge]
    }
}

#Vertex: {
    name: string
    source?: {}
    udf?: {
        builtin?: {
            name: string
        }
    }
    sink?: {
        log?: {}
    }
}

#Edge: {
    from: string
    to: string
}