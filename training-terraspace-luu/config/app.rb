# Docs: https://terraspace.cloud/docs/config/reference/
Terraspace.configure do |config|
  config.logger.level = :info
  config.build.cache_dir = ":ENV/:BUILD_DIR"
  config.allow.envs = ["dev"]
  config.test_framework = "rspec"
  config.all.concurrency = 5
  config.all.exit_on_fail.plan = false
  config.all.exit_on_fail.up = true
 end
 
 TerraspacePluginAws.configure do |config|
  config.auto_create = true
  config.s3.block_public_access = true
  config.s3.encryption = true
  config.s3.enforce_ssl = true
  config.s3.lifecycle = true
  config.s3.versioning = true
 
  config.dynamodb.sse_type = "KMS"
  config.dynamodb.encryption = true
 end