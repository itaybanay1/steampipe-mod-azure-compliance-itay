query "manual_control" {
  sql = <<-EOQ
    select
      sub.subscription_id,
      'asdasd' as resource,
      'info' as status,
      'Manual verification required.' as reason
      
    from
      azure_compute_virtual_machine sub
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
