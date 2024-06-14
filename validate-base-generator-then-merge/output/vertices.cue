package main

vertices: [
  {
    name: "in",
    source: {
      generator: {
        rpu:      5,
        duration: "1s",
      },
    },
  },
  {
    name: "cat",
    udf: {
      builtin: {
        name: "cat",
      },
    },
  },
  {
    name: "out",
    sink: {
      log: {},
    },
  },
]