locals {
  regulatory_compliance_activedirectory_common_tags = {
    service = "Azure/ActiveDirectory"
  }
}

control "ad_guest_user_reviewed_monthly" {
  title       = "Ensure guest users are reviewed on a monthly basis"
  description = "Guest users allow you to share your company's applications and services with users from any other organization, while maintaining control over your own corporate data. Guest users should be review on a monthly basis to ensure that inactive and unneeded accounts are removed."
  query       = query.ad_guest_user_reviewed_monthly

  tags = local.regulatory_compliance_activedirectory_common_tags
}

query "ad_guest_user_reviewed_monthly" {
  sql = <<-EOQ
    select
      u.display_name as resource,
      case
        when not account_enabled then 'alarm'
        when u.created_date_time::timestamp <= (current_date - interval '30' day) then 'alarm'
        else 'ok'
      end as status,
      case
        when not account_enabled then 'Guest user ''' || u.display_name || ''' inactive.'
        else 'Guest user ''' || u.display_name || ''' was created ' || extract(day from current_timestamp - u.created_date_time::timestamp) || ' days ago.'
      end as reason,
      t.tenant_id,
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
      ${replace(local.common_dimensions_subscription_id_qualifier_sql, "__QUALIFIER__", "t.")}
    from
      azuread_user as u
    left join 
      azure_tenant as t 
    on 
      t.tenant_id = u.tenant_id
    join
      azure_compute_virtual_machine comp
    on
      comp.subscription_id = t.subscription_id 
    where
      u.user_type = 'Guest';
  EOQ
}

query "ad_manual_control" {
  sql = <<-EOQ
    select
        'active_directory' as resource,
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
        azure_compute_virtual_machine comp;
  EOQ
}
