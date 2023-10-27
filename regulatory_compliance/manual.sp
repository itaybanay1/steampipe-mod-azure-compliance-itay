query "manual_control" {
  sql = <<-EOQ
    select
      sub.id as resource,
      'info' as status,
      'Manual verification required.' as reason,
      comp.id,
      comp.type,
      comp.vm_id,
      comp.size,
      comp.allow_extension_operations,
      comp.computer_name,
      comp.disable_password_authentication,
      comp.image_exact_version,
      comp.image_id,
      comp.os_version,
      comp.os_name,
      comp.os_type
    from
      azure_compute_virtual_machine comp
    join 
      azure_subscription sub
    on 
      comp.subscription_id = sub.subscription_id; 
  EOQ
}

query "manual_control_hipaa" {
  sql = <<-EOQ
    select
      id as resource,
      'info' as status,
      'Manual verification required. Check control description for more details.' as reason,
      display_name as subscription
    from
      azure_subscription;
  EOQ
}
