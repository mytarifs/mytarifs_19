# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_tarif_session'
#Rails.application.config.session_store :cache_store, key: '_tarif_session'
Rails.application.config.session_store :cache_store,
  cache: Readthis::Cache.new,
  expire_after: 2.weeks.to_i