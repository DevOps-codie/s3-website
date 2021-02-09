variable "env" {
  default = ""
  description = "environment to build"
}

variable redirect_to {
  type        = string
  default     = ""
  description = "Where to redirect requests to, if not set the cloudfront distribution host will be used"
}
