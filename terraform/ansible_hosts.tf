resource "local_file" "build_ansible_hosts_file" {
  filename = "../ansible/hosts"
  content = templatefile("templates/hosts",
    {
      jump_host_public        = local.jump_host_public_address,
      jump_host_keyfile       = aws_key_pair.admin_key.key_name,
      kali_host_keyfile       = aws_key_pair.kali_key.key_name,
      freedns_ipv4_update_url = var.freedns_ipv4_update_url,
      freedns_ipv6_update_url = var.freedns_ipv6_update_url,
      freedns_domain_name     = var.freedns_domain_name,
      freedns_email           = var.freedns_email,
      kali_host_vnc_password  = var.kali_host_vnc_password,
      guac_admin_pass         = var.guac_admin_pass,
      guac_kali_pass_base     = var.guac_kali_pass_pass,
      kali_instances          = aws_instance.kali_host
    }
  )
  depends_on = [
    aws_instance.jump_host,
    aws_instance.kali_host,
  ]
}
