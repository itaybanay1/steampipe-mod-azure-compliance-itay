query "manual_control" {
  sql = <<-EOQ
    select
      sub.id as resource,
      'info' as status,
      'Manual verification required.' as reason,
      sub.display_name as subscription,
      app.*
    from
      azure_app_service_web_app app
    join
      azure_subscription sub
    on 
      sub.subscription_id = app.subscription_id;
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
