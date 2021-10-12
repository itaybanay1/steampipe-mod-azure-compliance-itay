with all_function_app as (
  select
    id
  from
    azure_app_service_function_app
  where
    exists (
      select
      from
        unnest(regexp_split_to_array(kind, ',')) elem
      where
        elem like 'functionapp%'
    )
    and
    exists (
      select
      from
        unnest(regexp_split_to_array(kind, ',')) elem
      where
        elem = 'linux'
    )
)
select
  -- Required Columns
  a.id as resource,
  case
    when b.id is null then 'skip'
    when configuration -> 'properties' ->> 'linuxFxVersion' not like 'Python%' then 'ok'
    when configuration -> 'properties' ->> 'linuxFxVersion' = 'Python|3.9' then 'ok'
    else 'alarm'
  end as status,
  case
    when b.id is null then a.title || ' is ' || a.kind || ' kind.'
    when configuration -> 'properties' ->> 'linuxFxVersion' not like 'Python%' then a.name || ' not using python version.'
    when configuration -> 'properties' ->> 'linuxFxVersion' = 'Python|3.9' then a.name || ' using the latest python version.'
    else a.name || ' not using latest python version.'
  end as reason,
  -- Additional Dimensions
  resource_group,
  sub.display_name as subscription
from
  azure_app_service_function_app as a
  left join all_function_app as b on a.id = b.id,
  azure_subscription as sub
where
  sub.subscription_id = a.subscription_id;