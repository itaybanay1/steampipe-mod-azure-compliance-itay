query "manual_control" {
  sql = <<-EOQ
    select
      sub.id as resource,
      'info' as status,
      'Manual verification required.' as reason,
      sub.display_name as subscription,
      sub.*
    from
      azure_subscription as sub;
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
