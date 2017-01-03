def migration_has_been_run?(version)
  table_name = ActiveRecord::Migrator.schema_migrations_table_name
  query = "SELECT version FROM %s WHERE version = '%s'" % [table_name, version]
  ActiveRecord::Base.connection.clear_query_cache
  ActiveRecord::Base.connection.execute(query).any?
end

def test_migrate(migration_class, migration_number, way, reset_classes = nil)
  reset_classes ||= []

  verbosity = ActiveRecord::Migration.verbose
  ActiveRecord::Migration.verbose = false

  migration = migration_class.new
  case way
  when :up
    migration.migrate(:up)# unless migration_has_been_run?(migration_number)
  when :down
    migration.migrate(:down)# if migration_has_been_run?(migration_number)
  end

  reset_classes.each do |klass|
    klass.connection.schema_cache.clear!
    klass.reset_column_information
  end

  ActiveRecord::Migration.verbose = verbosity
end
