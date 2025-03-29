variable "compartment" {
    type = string
    //default = "ocid1.compartment.oc1..aaaaaaaaeabcuiskvhvuvzrmjde5wtc4hb3xu5uqpe3nh62n6pknw4rppsna"
}

variable "public_subnet" {
    type =string
    //default = "ocid1.subnet.oc1.phx.aaaaaaaa52lpbh56tngwec3ks4ztljwrepfevdpe6u535aqnkvycq7iu7bca"
}

variable "private_subnet" {
    type = string
}

variable "kubernetes_version" {
    type = string
    //default = "v1.32.1"
}

variable "cluster_name" {
    type = string
    //default= "challenge-cluster"
}

variable "pods_cidr" {
    type = string
    //default = "10.244.0.0/16"
}

variable "services_cidr" {
    type = string
    //default = "10.96.0.0/16"
}

variable "vcn" {
    type = string
    //default = "ocid1.vcn.oc1.phx.amaaaaaafioir7ial5636ct25xbcmbggxjhi3ujfg4c5o3nim37r7q37mduq"
}

variable "shape_config" {
    type = object({
      memory = string,
      ocpus = string
    })
}