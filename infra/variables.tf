variable "env" {
  default = ""
  description = "environment to build"
}

variable redirect_to {
  type        = string
  default     = ""
  description = "Where to redirect requests to, if not set the cloudfront distribution host will be used"
}

variable domain_name {
  type        = string
  default     = ""
  description = "What is the name of the domain you would like to use ex bar.foo.com"
}

variable hosted_zone {
  type        = string
  default     = ""
  description = "the hosted zone you will use ex foo.com"
}

