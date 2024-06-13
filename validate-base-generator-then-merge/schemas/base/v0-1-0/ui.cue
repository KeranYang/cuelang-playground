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
}

#Edge: {
    from: string
    to: string
}