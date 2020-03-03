variable "projects" {
  type = map(object({
    name = string
    access = string
  }))
}

